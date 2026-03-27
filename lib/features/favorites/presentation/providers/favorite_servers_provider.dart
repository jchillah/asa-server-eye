// features/favorites/presentation/providers/favorite_servers_provider.dart
import 'package:asa_server_eye/features/servers/presentation/providers/servers_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../servers/domain/server.dart';
import '../controllers/favorites_controller.dart';

final favoriteServersProvider = Provider.autoDispose<AsyncValue<List<Server>>>((
  ref,
) {
  final favoriteIdsAsync = ref.watch(favoriteIdsProvider);
  final serversAsync = ref.watch(serversProvider);

  if (favoriteIdsAsync.isLoading || serversAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (favoriteIdsAsync.hasError) {
    return AsyncValue.error(
      favoriteIdsAsync.error!,
      favoriteIdsAsync.stackTrace!,
    );
  }

  if (serversAsync.hasError) {
    return AsyncValue.error(serversAsync.error!, serversAsync.stackTrace!);
  }

  final favoriteIds = favoriteIdsAsync.value ?? [];
  final servers = serversAsync.value ?? [];

  final filtered = servers.where((s) => favoriteIds.contains(s.id)).toList();

  return AsyncValue.data(filtered);
});
