// features/servers/presentation/controllers/server_sync_controller.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/server_repository.dart';
import '../../domain/server.dart';
import '../providers/servers_provider.dart';

final serverSyncControllerProvider =
    StateNotifierProvider<ServerSyncController, AsyncValue<List<Server>>>((
      ref,
    ) {
      final repository = ref.watch(serverRepositoryProvider);
      return ServerSyncController(repository)..start();
    });

class ServerSyncController extends StateNotifier<AsyncValue<List<Server>>> {
  ServerSyncController(this._repository) : super(const AsyncValue.loading());

  final ServerRepository _repository;

  Timer? _timer;

  void start() {
    fetchServers();

    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      fetchServers();
    });
  }

  Future<void> fetchServers() async {
    try {
      final servers = await _repository.fetchServers();

      state = AsyncValue.data(servers);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
