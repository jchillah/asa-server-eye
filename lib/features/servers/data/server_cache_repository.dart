// features/servers/data/server_cache_repository.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/app_logger.dart';
import '../domain/server.dart';

class ServerCacheRepository {
  static const _serversJsonKey = 'cached_servers_json';
  static const _lastUpdatedAtKey = 'cached_servers_last_updated_at';

  SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> saveServers(List<Server> servers) async {
    final prefs = await _prefs;
    final encoded = jsonEncode(servers.map(_encodeServer).toList());
    final lastUpdatedAt = DateTime.now().toUtc();

    await prefs.setString(_serversJsonKey, encoded);
    await prefs.setString(
      _lastUpdatedAtKey,
      lastUpdatedAt.toIso8601String(),
    );

    AppLogger.info(
      'ServerCacheRepository',
      'Saved ${servers.length} servers to cache.',
    );
  }

  Future<List<Server>?> getCachedServers() async {
    final prefs = await _prefs;
    final encoded = prefs.getString(_serversJsonKey);

    if (encoded == null || encoded.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(encoded);

      if (decoded is! List) {
        AppLogger.warning(
          'ServerCacheRepository',
          'Cached server data is not a JSON array.',
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

      return servers.isEmpty ? null : servers;
    } catch (error, stackTrace) {
      AppLogger.error(
        'ServerCacheRepository',
        'Failed to decode cached servers.',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<DateTime?> getLastUpdatedAt() async {
    final prefs = await _prefs;
    final value = prefs.getString(_lastUpdatedAtKey);

    if (value == null || value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.remove(_serversJsonKey);
    await prefs.remove(_lastUpdatedAtKey);

    AppLogger.info('ServerCacheRepository', 'Cleared cached server data.');
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
