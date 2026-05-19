// features/servers/presentation/providers/server_cache_repository_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/server_cache_repository.dart';

final serverCacheRepositoryProvider = Provider<ServerCacheRepository>((ref) {
  return ServerCacheRepository();
});
