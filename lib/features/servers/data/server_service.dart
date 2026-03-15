// features/servers/data/server_service.dart
import 'package:dio/dio.dart';

import '../domain/server.dart';

class ServerService {
  ServerService(this._dio);

  final Dio _dio;

  static const String serverListUrl =
      'https://cdn2.arkdedicated.com/servers/asa/officialserverlist.json';

  Future<List<Server>> fetchServers() async {
    final response = await _dio.get(serverListUrl);

    if (response.statusCode != 200) {
      throw Exception('Failed to load server list');
    }

    final data = response.data;
    if (data is! List) {
      throw Exception('Invalid server list response');
    }

    return data
        .whereType<Map>()
        .map((raw) => Map<String, dynamic>.from(raw))
        .map(_mapServer)
        .toList();
  }

  Server _mapServer(Map<String, dynamic> json) {
    final sessionId = (json['SessionId'] ?? '').toString().trim();
    final name = (json['Name'] ?? '').toString().trim();
    final map = (json['MapName'] ?? '').toString().trim();
    final ip = (json['IP'] ?? json['Ip'] ?? '').toString().trim();
    final port = (json['Port'] ?? '').toString().trim();

    return Server(
      id: _buildServerId(
        sessionId: sessionId,
        name: name,
        map: map,
        ip: ip,
        port: port,
      ),
      name: name.isNotEmpty ? name : 'Unknown Server',
      map: map.isNotEmpty ? map : 'Unknown Map',
      players: _toInt(json['NumPlayers']),
      maxPlayers: _toInt(json['MaxPlayers']),
      official: json['OfficialServer'] == true,
    );
  }

  String _buildServerId({
    required String sessionId,
    required String name,
    required String map,
    required String ip,
    required String port,
  }) {
    if (sessionId.isNotEmpty) {
      return sessionId;
    }

    final ipPort = [ip, port].where((value) => value.isNotEmpty).join(':');
    if (ipPort.isNotEmpty) {
      return '$name|$map|$ipPort';
    }

    return '$name|$map';
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
