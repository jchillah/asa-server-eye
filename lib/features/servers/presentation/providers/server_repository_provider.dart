// features/servers/presentation/providers/server_repository_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/server_repository.dart';
import 'dio_provider.dart';

final serverRepositoryProvider = Provider<ServerRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ServerRepository(dio);
});
