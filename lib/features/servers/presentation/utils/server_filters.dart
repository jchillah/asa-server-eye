// features/servers/presentation/utils/server_filters.dart
import '../../domain/server.dart';

abstract final class ServerFilters {
  static List<Server> byQuery({
    required List<Server> servers,
    required String query,
  }) {
    if (query.isEmpty) return servers;

    return servers.where((server) {
      final name = server.name.toLowerCase();
      final map = server.map.toLowerCase();

      return name.contains(query) || map.contains(query);
    }).toList();
  }
}
