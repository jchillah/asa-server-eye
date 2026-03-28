// features/servers/presentation/providers/server_sync_provider.dart
import 'package:asa_server_eye/features/servers/presentation/controllers/server_sync_controller.dart';
import 'package:asa_server_eye/features/servers/presentation/providers/server_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/server.dart';

final serverSyncProvider =
    StateNotifierProvider.autoDispose<
      ServerSyncController,
      AsyncValue<List<Server>>
    >((ref) {
      final repository = ref.watch(serverRepositoryProvider);
      final controller = ServerSyncController(repository);

      controller.fetchServers();

      return controller;
    });
