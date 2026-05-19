// features/servers/data/server_cache_repository.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/server.dart';

class ServerCacheRepository {
  ServerCacheRepository(this._preferences);

  final SharedPreferences _preferences;

  static const _serversJsonKey = 'cached_servers_json';
  static const _lastUpdatedAtKey = 'cached_servers_last_updated_at';

  Future<void> saveServers(List<Server> servers) async {
    final encoded = jsonEncode(servers.map(_encodeServer).toList());
    final lastUpdatedAt = DateTime.now().toUtc();

    await _preferences.setString(_serversJsonKey, encoded);
    await _preferences.setString(
      _lastUpdatedAtKey,
      lastUpdatedAt.toIso8601String(),
    );

    AppLogger.info(
      'ServerCacheRepository',
      'Saved ${servers.length} servers to cache.',
    );
  }

  Future<List<Server>?> getCachedServers() async {
    final encoded = _preferences.getString(_serversJsonKey);

    if (encoded == null || encoded.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(encoded);

      if (decoded is! List) {
        await _clearServersCache();
        AppLogger.warning(
          'ServerCacheRepository',
          'Cached server data is not a JSON array. Cleared corrupted cache.',
        );
        return null;
      }

      final servers = <Server>[];

      for (final item in decoded) {
        if (item is! Map<String, dynamic>) {
          continue;
        }

        servers.add(_decodeServer(item));
      }

      if (servers.isEmpty) {
        return null;
      }

      final lastUpdatedAt = getLastUpdatedAt();
      AppLogger.info(
        'ServerCacheRepository',
        'Loaded ${servers.length} servers from cache '
        '(lastUpdatedAt: $lastUpdatedAt).',
      );

      return servers;
    } catch (error, stackTrace) {
      await _clearServersCache();
      AppLogger.error(
        'ServerCacheRepository',
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

    AppLogger.info('ServerCacheRepository', 'Cleared cached server data.');
  }

  Future<void> _clearServersCache() async {
    await _preferences.remove(_serversJsonKey);
    await _preferences.remove(_lastUpdatedAtKey);
  }

  static Map<String, dynamic> _encodeServer(Server server) {
    return {
      'id': server.id,
      'name': server.name,
      'map': server.map,
      'players': server.players,
      'maxPlayers': server.maxPlayers,
      'official': server.official,
    };
  }

  static Server _decodeServer(Map<String, dynamic> json) {
    return Server(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Server',
      map: json['map']?.toString() ?? 'Unknown Map',
      players: _readInt(json['players']),
      maxPlayers: _readInt(json['maxPlayers']),
      official: json['official'] == true,
    );
  }

  static int _readInt(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }
}
