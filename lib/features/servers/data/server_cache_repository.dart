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
  static const _cacheSchemaVersion = 1;
  static const _cacheNamespace = 'asa_server_eye.servers.v$_cacheSchemaVersion';

  static const _serversJsonKey = '$_cacheNamespace.cached_servers_json';
  static const _lastUpdatedAtKey =
      '$_cacheNamespace.cached_servers_last_updated_at';

  static const _tempServersJsonKey = '$_serversJsonKey.tmp';
  static const _tempLastUpdatedAtKey = '$_lastUpdatedAtKey.tmp';

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

      final encoded = jsonEncode(validServers.map(_encodeServer).toList());
      final normalizedLastUpdatedAt = lastUpdatedAt.toUtc();

      final didWriteTempServers = await _preferences.setString(
        _tempServersJsonKey,
        encoded,
      );

      final didWriteTempTimestamp = await _preferences.setString(
        _tempLastUpdatedAtKey,
        normalizedLastUpdatedAt.toIso8601String(),
      );

      if (!didWriteTempServers || !didWriteTempTimestamp) {
        await _clearTempServersCache();

        AppLogger.warning(
          _logTag,
          'SharedPreferences reported an unsuccessful temporary cache write.',
        );
        return;
      }

      final didSaveServers = await _preferences.setString(
        _serversJsonKey,
        encoded,
      );

      final didSaveTimestamp = await _preferences.setString(
        _lastUpdatedAtKey,
        normalizedLastUpdatedAt.toIso8601String(),
      );

      await _clearTempServersCache();

      if (!didSaveServers || !didSaveTimestamp) {
        await _clearServersCache();

        AppLogger.warning(
          _logTag,
          'SharedPreferences reported an unsuccessful cache commit. Cleared cache to avoid inconsistent state.',
        );
        return;
      }

      AppLogger.info(
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
    final encoded = _preferences.getString(_serversJsonKey);

    if (encoded == null || encoded.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(encoded);

      if (decoded is! List) {
        await _clearCorruptedServersCache(
          reason: 'Cached server data is not a JSON array.',
        );
        return null;
      }

      final servers = <Server>[];
      var skippedItems = 0;

      for (final item in decoded) {
        if (item is! Map) {
          skippedItems++;

          AppLogger.warning(
            _logTag,
            'Skipped cached server item because it is not a JSON object.',
          );

          continue;
        }

        final json = Map<String, dynamic>.from(item);
        final server = _decodeServer(json);

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

      if (servers.isEmpty) {
        await _clearCorruptedServersCache(
          reason:
              'Cached server data did not contain any valid servers. Cleared corrupted cache.',
        );
        return null;
      }

      final lastUpdatedAt = getLastUpdatedAt();

      AppLogger.info(
        _logTag,
        'Loaded ${servers.length} servers from cache '
        '(skippedItems: $skippedItems, lastUpdatedAt: $lastUpdatedAt).',
      );

      return servers;
    } catch (error, stackTrace) {
      await _clearCorruptedServersCache(
        reason: 'Failed to decode cached servers.',
      );

      AppLogger.error(
        _logTag,
        'Failed to decode cached servers. Cleared corrupted cache.',
        error: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  DateTime? getLastUpdatedAt() {
    final value = _preferences.getString(_lastUpdatedAtKey);

    if (value == null || value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  Future<void> clear() async {
    await _clearServersCache();

    AppLogger.info(_logTag, 'Cleared cached server data.');
  }

  Future<void> _clearCorruptedServersCache({required String reason}) async {
    await _clearServersCache();

    AppLogger.warning(_logTag, reason);
  }

  Future<void> _clearServersCache() async {
    await _preferences.remove(_serversJsonKey);
    await _preferences.remove(_lastUpdatedAtKey);
    await _clearTempServersCache();
  }

  Future<void> _clearTempServersCache() async {
    await _preferences.remove(_tempServersJsonKey);
    await _preferences.remove(_tempLastUpdatedAtKey);
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
