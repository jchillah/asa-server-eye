// features/favorites/presentation/providers/favorite_servers_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../servers/domain/server.dart';
import '../../../servers/presentation/providers/server_providers.dart';
import '../controllers/favorites_controller.dart';

final favoriteServersProvider = Provider<AsyncValue<List<Server>>>((ref) {
  final favoriteIdsAsync = ref.watch(favoriteIdsProvider);
  final serversAsync = ref.watch(serversProvider);

  if (favoriteIdsAsync.hasError) {
    return AsyncValue.error(
      favoriteIdsAsync.error!,
      favoriteIdsAsync.stackTrace!,
    );
  }

  if (serversAsync.hasError) {
    return AsyncValue.error(serversAsync.error!, serversAsync.stackTrace!);
  }

  if (favoriteIdsAsync.isLoading || serversAsync.isLoading) {
    return const AsyncValue.loading();
  }

  final favoriteIds = favoriteIdsAsync.value ?? <String>[];
  final servers = serversAsync.value ?? <Server>[];

  final favoriteServers = servers
      .where((server) => favoriteIds.contains(server.id))
      .toList();

  return AsyncValue.data(favoriteServers);
});
