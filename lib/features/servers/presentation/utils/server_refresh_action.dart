// features/servers/presentation/utils/server_refresh_action.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/server_sync_controller.dart';

abstract final class ServerRefreshAction {
  static Future<void> run(WidgetRef ref) async {
    await ref.read(serverSyncControllerProvider.notifier).fetchServers();
  }
}
