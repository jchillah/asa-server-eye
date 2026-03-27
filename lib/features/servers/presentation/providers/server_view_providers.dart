// features/servers/presentation/providers/server_view_providers.dart
import 'package:asa_server_eye/features/servers/presentation/providers/servers_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../favorites/presentation/controllers/favorites_controller.dart';
import '../../domain/server.dart';
import '../controllers/server_search_controller.dart';
import '../utils/server_filters.dart';
import '../utils/server_lookup.dart';

final filteredServersProvider = Provider.autoDispose<AsyncValue<List<Server>>>((
  ref,
) {
  final query = ref.watch(
    serverSearchControllerProvider.select((c) => c.query),
  );

  final serversAsync = ref.watch(serversProvider);

  return serversAsync.whenData(
    (servers) => ServerFilters.byQuery(servers: servers, query: query),
  );
});

final serverByIdProvider = Provider.family<AsyncValue<Server?>, String>((
  ref,
  serverId,
) {
  final serversAsync = ref.watch(serversProvider);

  return serversAsync.whenData(
    (servers) => ServerLookup.byId(servers, serverId),
  );
});

final isFavoriteServerProvider = Provider.family<AsyncValue<bool>, String>((
  ref,
  serverId,
) {
  final favoriteIdsAsync = ref.watch(favoriteIdsProvider);

  return favoriteIdsAsync.whenData((favoriteIds) {
    return favoriteIds.contains(serverId);
  });
});
