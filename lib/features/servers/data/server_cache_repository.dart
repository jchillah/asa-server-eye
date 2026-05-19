// features/servers/data/server_cache_repository.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/server.dart';

class ServerCacheRepository {
  ServerCacheRepository(this._preferences);

  final SharedPreferences _preferences;

  static const _logTag = 'ServerCacheRepository';

  /// Cache namespace strategy:
  ///
  /// Increase [_cacheSchemaVersion] whenever the cached server JSON shape changes
  /// in a breaking way. This prevents new app versions from reading stale cache
  /// entries written by older schemas.
  static const _cacheSchemaVersion = 2;
  static const _cacheNamespace = 'asa_server_eye.servers.v$_cacheSchemaVersion';

  static const _cacheBlobKey = '$_cacheNamespace.cache_blob';
  static const _tempCacheBlobKey = '$_cacheBlobKey.tmp';

  Future<void> saveServers(
    List<Server> servers, {
    required DateTime lastUpdatedAt,
  }) async {
    try {
      final validServers = servers
          .where((server) => server.id.trim().isNotEmpty)
          .toList(growable: false);

      if (validServers.isEmpty) {
        AppLogger.warning(
          _logTag,
          'Skipped saving server cache because no valid servers were provided.',
        );
        return;
      }

      final normalizedLastUpdatedAt = lastUpdatedAt.toUtc();

      final cacheBlob = <String, dynamic>{
        'schemaVersion': _cacheSchemaVersion,
        'lastUpdatedAt': normalizedLastUpdatedAt.toIso8601String(),
        'servers': validServers.map(_encodeServer).toList(),
      };

      final encoded = jsonEncode(cacheBlob);

      final didWriteTempBlob = await _preferences.setString(
        _tempCacheBlobKey,
        encoded,
      );

      if (!didWriteTempBlob) {
        await _clearTempServersCache();

        AppLogger.warning(
          _logTag,
          'SharedPreferences reported an unsuccessful temporary cache write.',
        );
        return;
      }

      final didSaveBlob = await _preferences.setString(_cacheBlobKey, encoded);

      await _clearTempServersCache();

      if (!didSaveBlob) {
        await _clearServersCache();

        AppLogger.warning(
          _logTag,
          'SharedPreferences reported an unsuccessful cache commit. Cleared cache to avoid inconsistent state.',
        );
        return;
      }

      AppLogger.debug(
        _logTag,
        'Saved ${validServers.length} servers to cache '
        '(lastUpdatedAt: $normalizedLastUpdatedAt).',
      );
    } catch (error, stackTrace) {
      await _clearTempServersCache();

      AppLogger.error(
        _logTag,
        'Failed to save servers to cache. Existing cache was left untouched.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<Server>?> getCachedServers() async {
    final cache = _readCacheBlob();

    if (cache == null) {
      return null;
    }

    final servers = cache.servers;

    if (servers.isEmpty) {
      await _clearCorruptedServersCache(
        reason:
            'Cached server data did not contain any valid servers. Cleared corrupted cache.',
      );
      return null;
    }

    AppLogger.debug(
      _logTag,
      'Loaded ${servers.length} servers from cache '
      '(skippedItems: ${cache.skippedItems}, lastUpdatedAt: ${cache.lastUpdatedAt}).',
    );

    return servers;
  }

  DateTime? getLastUpdatedAt() {
    return _readCacheBlob()?.lastUpdatedAt;
  }

  Future<void> clear() async {
    await _clearServersCache();

    AppLogger.info(_logTag, 'Cleared cached server data.');
  }

  _DecodedServerCache? _readCacheBlob() {
    final encoded = _preferences.getString(_cacheBlobKey);

    if (encoded == null || encoded.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(encoded);

      if (decoded is! Map) {
        _scheduleCorruptedCacheClear(
          reason: 'Cached server data is not a JSON object.',
        );
        return null;
      }

      final json = Map<String, dynamic>.from(decoded);

      final schemaVersion = _readInt(json['schemaVersion']);
      if (schemaVersion != _cacheSchemaVersion) {
        _scheduleCorruptedCacheClear(
          reason:
              'Cached server schema version mismatch. Expected $_cacheSchemaVersion but got $schemaVersion.',
        );
        return null;
      }

      final lastUpdatedAt = _readDateTime(json['lastUpdatedAt']);

      if (lastUpdatedAt == null) {
        _scheduleCorruptedCacheClear(
          reason: 'Cached server data has no valid lastUpdatedAt timestamp.',
        );
        return null;
      }

      final rawServers = json['servers'];

      if (rawServers is! List) {
        _scheduleCorruptedCacheClear(
          reason: 'Cached server data servers field is not a JSON array.',
        );
        return null;
      }

      final servers = <Server>[];
      var skippedItems = 0;

      for (final item in rawServers) {
        if (item is! Map) {
          skippedItems++;

          AppLogger.warning(
            _logTag,
            'Skipped cached server item because it is not a JSON object.',
          );

          continue;
        }

        final serverJson = Map<String, dynamic>.from(item);
        final server = _decodeServer(serverJson);

        if (server == null) {
          skippedItems++;

          AppLogger.warning(
            _logTag,
            'Skipped cached server item because id is missing or empty.',
          );

          continue;
        }

        servers.add(server);
      }

      return _DecodedServerCache(
        servers: servers,
        lastUpdatedAt: lastUpdatedAt,
        skippedItems: skippedItems,
      );
    } catch (error, stackTrace) {
      _scheduleCorruptedCacheClear(reason: 'Failed to decode cached servers.');

      AppLogger.error(
        _logTag,
        'Failed to decode cached servers. Cleared corrupted cache.',
        error: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  void _scheduleCorruptedCacheClear({required String reason}) {
    AppLogger.warning(_logTag, '$reason Clearing corrupted cache.');

    Future<void>(() async {
      await _clearServersCache();
    });
  }

  Future<void> _clearCorruptedServersCache({required String reason}) async {
    await _clearServersCache();

    AppLogger.warning(_logTag, reason);
  }

  Future<void> _clearServersCache() async {
    await _preferences.remove(_cacheBlobKey);
    await _clearTempServersCache();
  }

  Future<void> _clearTempServersCache() async {
    await _preferences.remove(_tempCacheBlobKey);
  }

  static Map<String, dynamic> _encodeServer(Server server) {
    return {
      'id': server.id.trim(),
      'name': server.name.trim(),
      'map': server.map.trim(),
      'players': server.players,
      'maxPlayers': server.maxPlayers,
      'official': server.official,
    };
  }

  static Server? _decodeServer(Map<String, dynamic> json) {
    final id = json['id']?.toString().trim() ?? '';

    if (id.isEmpty) {
      return null;
    }

    return Server(
      id: id,
      name: _readNonEmptyString(json['name'], fallback: 'Unknown Server'),
      map: _readNonEmptyString(json['map'], fallback: 'Unknown Map'),
      players: _readInt(json['players']),
      maxPlayers: _readInt(json['maxPlayers']),
      official: _readBool(json['official']),
    );
  }

  static DateTime? _readDateTime(Object? value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value.trim());
  }

  static String _readNonEmptyString(Object? value, {required String fallback}) {
    final normalized = value?.toString().trim();

    if (normalized == null || normalized.isEmpty) {
      return fallback;
    }

    return normalized;
  }

  static int _readInt(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value.trim()) ?? 0;
    }

    return 0;
  }

  static bool _readBool(Object? value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }

    return false;
  }
}

class _DecodedServerCache {
  const _DecodedServerCache({
    required this.servers,
    required this.lastUpdatedAt,
    required this.skippedItems,
  });

  final List<Server> servers;
  final DateTime lastUpdatedAt;
  final int skippedItems;
}
