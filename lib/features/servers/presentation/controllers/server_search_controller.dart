// features/servers/presentation/controllers/server_search_controller.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serverSearchControllerProvider =
    ChangeNotifierProvider.autoDispose<ServerSearchController>((ref) {
      return ServerSearchController();
    });

class ServerSearchController extends ChangeNotifier {
  ServerSearchController();

  final TextEditingController textController = TextEditingController();

  Timer? _debounce;
  String _query = '';

  String get query => _query;

  void updateQuery(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      final normalized = value.trim().toLowerCase();

      if (_query == normalized) {
        return;
      }

      _query = normalized;
      notifyListeners();
    });
  }

  void clear() {
    _debounce?.cancel();
    textController.clear();

    if (_query.isEmpty) {
      return;
    }

    _query = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    textController.dispose();
    super.dispose();
  }
}
