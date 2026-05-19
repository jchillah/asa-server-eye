// features/servers/presentation/state/server_sync_state.dart
import '../../domain/server.dart';

class ServerSyncState {
  const ServerSyncState({
    required this.servers,
    required this.isFromCache,
    this.lastUpdatedAt,
  });

  final List<Server> servers;
  final DateTime? lastUpdatedAt;
  final bool isFromCache;

  bool get hasServers => servers.isNotEmpty;
}
