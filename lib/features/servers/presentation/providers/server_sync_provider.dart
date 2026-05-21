// features/servers/presentation/providers/server_sync_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/presentation/controllers/app_shell_controller.dart';
import '../controllers/server_sync_controller.dart';
import '../state/server_sync_state.dart';
import 'server_repository_provider.dart';

final serverSyncProvider =
    StateNotifierProvider.autoDispose<
      ServerSyncController,
      AsyncValue<ServerSyncState>
    >((ref) {
      final repository = ref.watch(serverRepositoryProvider);
      final shouldSyncServers = ref.watch(shouldSyncServersProvider);
      final controller = ServerSyncController(repository);

      if (shouldSyncServers) {
        controller.start();
      }

      ref.onDispose(controller.stop);

      return controller;
    });
