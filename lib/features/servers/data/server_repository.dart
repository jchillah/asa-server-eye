// features/servers/data/server_repository.dart
import 'package:dio/dio.dart';

import '../../../core/utils/app_logger.dart';
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
        throw const FormatException('Invalid server response format.');
      }

      final servers = <Server>[];

      for (final item in data) {
        if (item is! Map<String, dynamic>) {
          AppLogger.warning(
            'ServerRepository',
            'Skipped invalid server item because it is not a JSON object.',
          );
          continue;
        }

        final server = Server.fromJson(item);

        if (server.id.isEmpty) {
          AppLogger.warning(
            'ServerRepository',
            'Skipped server because no stable id could be resolved.',
          );
          continue;
        }

        servers.add(server);
      }

      AppLogger.info(
        'ServerRepository',
        'Loaded ${servers.length} servers successfully.',
      );

      return servers;
    } catch (error, stackTrace) {
      AppLogger.error(
        'ServerRepository',
        'Failed to fetch servers.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
