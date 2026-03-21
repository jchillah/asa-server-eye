// features/servers/presentation/utils/server_refresh_action.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/server_providers.dart';

abstract final class ServerRefreshAction {
  static Future<void> run(WidgetRef ref) async {
    ref.invalidate(serversProvider);
    await ref.read(serversProvider.future);
  }
}
