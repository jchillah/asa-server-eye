// features/servers/presentation/providers/server_by_id_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/server.dart';
import '../utils/server_lookup.dart';
import 'servers_provider.dart';

final serverByIdProvider = Provider.family<AsyncValue<Server?>, String>((
  ref,
  serverId,
) {
  final serversAsync = ref.watch(serversProvider);

  return serversAsync.whenData(
    (servers) => ServerLookup.byId(servers, serverId),
  );
});
