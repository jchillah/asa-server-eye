// features/servers/presentation/providers/servers_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/server.dart';
import '../state/server_sync_state.dart';
import 'server_sync_provider.dart';

final serversProvider = Provider.autoDispose<AsyncValue<ServerSyncState>>((ref) {
  return ref.watch(serverSyncProvider);
});

final serverListProvider = Provider.autoDispose<AsyncValue<List<Server>>>((ref) {
  final syncStateAsync = ref.watch(serversProvider);

  return syncStateAsync.whenData((syncState) => syncState.servers);
});
