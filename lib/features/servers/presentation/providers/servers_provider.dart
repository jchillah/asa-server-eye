// features/servers/presentation/providers/servers_provider.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/server_repository.dart';
import '../../domain/server.dart';
import '../controllers/server_sync_controller.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final serverRepositoryProvider = Provider<ServerRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ServerRepository(dio);
});

final serversProvider = Provider<AsyncValue<List<Server>>>((ref) {
  return ref.watch(serverSyncControllerProvider);
});
