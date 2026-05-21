// features/servers/presentation/state/server_sync_state.dart
import '../../domain/server.dart';
import '../../domain/server_sync_snapshot.dart';
import 'server_sync_error.dart';

class ServerSyncState {
  const ServerSyncState({required this.snapshot, this.lastError});

  factory ServerSyncState.fromSnapshot(ServerSyncSnapshot snapshot) {
    return ServerSyncState(snapshot: snapshot);
  }

  final ServerSyncSnapshot snapshot;
  final ServerSyncError? lastError;

  List<Server> get servers => snapshot.servers;
  DateTime? get lastUpdatedAt => snapshot.lastUpdatedAt;
  bool get isFromCache => snapshot.isFromCache;
  bool get isStale => snapshot.isStale;
  Duration? get cacheAge => snapshot.cacheAge;
  bool get hasServers => snapshot.hasServers;
  bool get hasLastError => lastError != null;

  ServerSyncState copyWith({
    ServerSyncSnapshot? snapshot,
    ServerSyncError? lastError,
    bool clearLastError = false,
  }) {
    return ServerSyncState(
      snapshot: snapshot ?? this.snapshot,
      lastError: clearLastError ? null : lastError ?? this.lastError,
    );
  }
}
