// features/servers/presentation/providers/servers_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/server.dart';
import 'server_sync_provider.dart';

final serversProvider = Provider.autoDispose<AsyncValue<List<Server>>>((ref) {
  return ref.watch(serverSyncProvider);
});
