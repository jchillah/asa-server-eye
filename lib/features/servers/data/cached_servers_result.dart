// features/servers/data/cached_servers_result.dart
import '../domain/server.dart';

class CachedServersResult {
  const CachedServersResult({
    required this.servers,
    required this.isFromCache,
    this.lastUpdatedAt,
  });

  final List<Server> servers;
  final DateTime? lastUpdatedAt;
  final bool isFromCache;
}
