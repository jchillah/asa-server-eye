// features/servers/data/server_service.dart
import 'package:dio/dio.dart';

import '../domain/server.dart';

class ServerService {
  final Dio _dio = Dio();

  static const String serverListUrl =
      "https://cdn2.arkdedicated.com/servers/asa/officialserverlist.json";

  Future<List<Server>> fetchServers() async {
    final response = await _dio.get(serverListUrl);

    final List data = response.data;

    return data.map((json) {
      return Server(
        id: json["SessionId"] ?? "",
        name: json["Name"] ?? "",
        map: json["MapName"] ?? "",
        players: json["NumPlayers"] ?? 0,
        maxPlayers: json["MaxPlayers"] ?? 0,
        official: json["OfficialServer"] ?? false,
      );
    }).toList();
  }
}
