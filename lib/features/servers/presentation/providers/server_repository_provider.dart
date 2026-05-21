// features/servers/presentation/providers/server_repository_provider.dart
import 'package:asa_server_eye/core/network/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/server_repository.dart';
import 'server_cache_repository_provider.dart';

final serverRepositoryProvider = Provider<ServerRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final cacheRepository = ref.watch(serverCacheRepositoryProvider);
  return ServerRepository(dio, cacheRepository);
});
