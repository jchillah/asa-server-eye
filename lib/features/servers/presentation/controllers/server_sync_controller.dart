// features/servers/presentation/controllers/server_sync_controller.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/server_repository.dart';
import '../../domain/server.dart';

class ServerSyncController extends StateNotifier<AsyncValue<List<Server>>> {
  ServerSyncController(
    this._repository, {
    Duration refreshInterval = const Duration(seconds: 10),
  }) : _refreshInterval = refreshInterval,
       super(const AsyncValue.loading());

  final ServerRepository _repository;
  final Duration _refreshInterval;

  Timer? _timer;
  bool _isFetching = false;

  void start() {
    if (_timer != null || !mounted) {
      return;
    }

    unawaited(fetchServers());

    _timer = Timer.periodic(_refreshInterval, (_) {
      if (!mounted) {
        return;
      }

      unawaited(fetchServers());
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> fetchServers() async {
    if (!mounted || _isFetching) {
      return;
    }

    _isFetching = true;

    final previous = state;

    if (!previous.hasValue && mounted) {
      state = const AsyncValue.loading();
    }

    try {
      final servers = await _repository.fetchServers();

      if (!mounted) {
        return;
      }

      state = AsyncValue.data(servers);
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      state = previous.hasValue
          ? AsyncValue<List<Server>>.error(
              error,
              stackTrace,
            ).copyWithPrevious(previous)
          : AsyncValue.error(error, stackTrace);
    } finally {
      _isFetching = false;
    }
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
