// features/servers/domain/server_sync_snapshot.dart
import 'server.dart';

class ServerSyncSnapshot {
  const ServerSyncSnapshot({
    required this.servers,
    required this.isFromCache,
    this.lastUpdatedAt,
  });

  final List<Server> servers;
  final DateTime? lastUpdatedAt;
  final bool isFromCache;

  bool get hasServers => servers.isNotEmpty;
}