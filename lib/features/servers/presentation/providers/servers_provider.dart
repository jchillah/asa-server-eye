// features/servers/presentation/providers/servers_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/server.dart';
import '../state/server_sync_error.dart';
import '../state/server_sync_state.dart';
import 'server_sync_provider.dart';

final serverSyncStateProvider =
    Provider.autoDispose<AsyncValue<ServerSyncState>>((ref) {
      return ref.watch(serverSyncProvider);
    });

@Deprecated(
  'Use serverSyncStateProvider for sync metadata or serverListProvider for the server list.',
)
final serversProvider = Provider.autoDispose<AsyncValue<ServerSyncState>>((
  ref,
) {
  return ref.watch(serverSyncStateProvider);
});

final serverListProvider = Provider.autoDispose<AsyncValue<List<Server>>>((
  ref,
) {
  final syncStateAsync = ref.watch(serverSyncStateProvider);

  return syncStateAsync.whenData((syncState) => syncState.servers);
});

final serverSyncErrorProvider = Provider.autoDispose<ServerSyncError?>((ref) {
  final syncStateAsync = ref.watch(serverSyncStateProvider);

  return syncStateAsync.whenOrNull(
    data: (syncState) => syncState.lastError,
    error: (error, stackTrace) => ServerSyncError(
      error: error,
      stackTrace: stackTrace,
      occurredAt: DateTime.now().toUtc(),
    ),
  );
});
