// features/servers/presentation/providers/filtered_servers_provider.dart
import 'package:asa_server_eye/features/servers/presentation/providers/server_search_provider.dart';
import 'package:asa_server_eye/features/servers/presentation/providers/servers_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/server.dart';
import '../utils/server_filters.dart';

final filteredServersProvider = Provider.autoDispose<AsyncValue<List<Server>>>((
  ref,
) {
  final query = ref.watch(serverSearchProvider.select((c) => c.query));

  final serversAsync = ref.watch(serversProvider);

  return serversAsync.whenData(
    (servers) => ServerFilters.byQuery(servers: servers, query: query),
  );
});
