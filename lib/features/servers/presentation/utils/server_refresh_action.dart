// features/servers/presentation/utils/server_refresh_action.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/server_sync_provider.dart';

abstract final class ServerRefreshAction {
  static Future<void> run(WidgetRef ref) async {
    await ref.read(serverSyncProvider.notifier).fetchServers();
  }
}
