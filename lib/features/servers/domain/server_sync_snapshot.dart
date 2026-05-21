// features/servers/domain/server_sync_snapshot.dart
import 'server.dart';

class ServerSyncSnapshot {
  const ServerSyncSnapshot({
    required this.servers,
    required this.isFromCache,
    required this.isStale,
    this.lastUpdatedAt,
    this.cacheAge,
  });

  final List<Server> servers;
  final DateTime? lastUpdatedAt;
  final bool isFromCache;
  final bool isStale;
  final Duration? cacheAge;

  bool get hasServers => servers.isNotEmpty;
}
