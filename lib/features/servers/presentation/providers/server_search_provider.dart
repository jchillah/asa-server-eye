// features/servers/presentation/providers/server_search_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/server_search_controller.dart';

final serverSearchProvider =
    ChangeNotifierProvider.autoDispose<ServerSearchController>((ref) {
      return ServerSearchController();
    });
