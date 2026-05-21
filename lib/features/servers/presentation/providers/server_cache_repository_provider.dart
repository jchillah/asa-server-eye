// features/servers/presentation/providers/server_cache_repository_provider.dart
import 'package:asa_server_eye/core/storage/shared_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/server_cache_repository.dart';

final serverCacheRepositoryProvider = Provider<ServerCacheRepository>((ref) {
  final preferences = ref.watch(sharedPreferencesProvider);
  return ServerCacheRepository(preferences);
});
