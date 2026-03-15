// features/servers/presentation/providers/server_providers.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/server_service.dart';
import '../../domain/server.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final serverServiceProvider = Provider<ServerService>((ref) {
  final dio = ref.watch(dioProvider);
  return ServerService(dio);
});

final serversProvider = FutureProvider<List<Server>>((ref) async {
  final service = ref.watch(serverServiceProvider);
  return service.fetchServers();
});
