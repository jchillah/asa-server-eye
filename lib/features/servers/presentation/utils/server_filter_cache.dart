// features/servers/presentation/utils/server_filter_cache.dart
import '../../domain/server.dart';
import 'server_filters.dart';

class ServerFilterCache {
  List<Server> _lastServers = const [];
  String _lastQuery = '';
  List<Server> _lastResult = const [];

  List<Server> filter({required List<Server> servers, required String query}) {
    final normalizedQuery = query.trim().toLowerCase();

    final isSameServers = identical(_lastServers, servers);
    final isSameQuery = _lastQuery == normalizedQuery;

    if (isSameServers && isSameQuery) {
      return _lastResult;
    }

    final result = ServerFilters.byQuery(
      servers: servers,
      query: normalizedQuery,
    );

    _lastServers = servers;
    _lastQuery = normalizedQuery;
    _lastResult = result;

    return result;
  }

  void clear() {
    _lastServers = const [];
    _lastQuery = '';
    _lastResult = const [];
  }
}
