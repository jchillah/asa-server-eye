// features/servers/data/server_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../domain/server.dart';

class ServerRepository {
  ServerRepository(this._dio);

  final Dio _dio;

  static const _url =
      'https://cdn2.arkdedicated.com/servers/asa/officialserverlist.json';

  Future<List<Server>> fetchServers() async {
    try {
      final response = await _dio.get(_url);

      final data = response.data;

      if (data is! List) {
        throw Exception('Invalid server response');
      }

      final servers = data.map<Server>((json) {
        final id = json['SessionID']?.toString();

        if (id == null || id.isEmpty) {
          debugPrint('⚠️ Server ohne gültige ID: ${json['Name']}');
        }

        final safeId = id != null && id.isNotEmpty
            ? id
            : json['Name']?.toString() ??
                  DateTime.now().millisecondsSinceEpoch.toString();

        return Server(
          id: safeId,
          name: json['Name'] ?? 'Unknown Server',
          map: json['MapName'] ?? 'Unknown Map',
          players: json['NumPlayers'] ?? 0,
          maxPlayers: json['MaxPlayers'] ?? 0,

          official: json['IsOfficial'] == 1 || json['IsOfficial'] == '1',
        );
      }).toList();

      debugPrint('✅ Loaded servers: ${servers.length}');

      return servers;
    } catch (e, stack) {
      debugPrint('🔥 SERVER FETCH ERROR: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }
}
