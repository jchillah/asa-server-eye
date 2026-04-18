// features/servers/presentation/providers/filtered_servers_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/server.dart';
import '../utils/server_filters.dart';
import 'server_search_provider.dart';
import 'servers_provider.dart';

final filteredServersProvider = Provider.autoDispose<AsyncValue<List<Server>>>((
  ref,
) {
  final query = ref.watch(
    serverSearchProvider.select((controller) {
      return controller.query;
    }),
  );

  final serversAsync = ref.watch(serversProvider);

  return serversAsync.whenData(
    (servers) => ServerFilters.byQuery(servers: servers, query: query),
  );
});
