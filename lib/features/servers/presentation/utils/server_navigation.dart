// features/servers/presentation/utils/server_navigation.dart
import 'package:flutter/material.dart';

import '../screens/server_detail_screen.dart';

abstract final class ServerNavigation {
  static Future<void> openDetails(BuildContext context, String serverId) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ServerDetailScreen(serverId: serverId)),
    );
  }
}
