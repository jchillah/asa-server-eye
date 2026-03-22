// features/settings/presentation/controllers/server_search_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serverSearchControllerProvider =
    ChangeNotifierProvider.autoDispose<ServerSearchController>((ref) {
      return ServerSearchController();
    });

class ServerSearchController extends ChangeNotifier {
  final textController = TextEditingController();

  String _query = '';

  String get query => _query;

  void updateQuery(String value) {
    _query = value.trim().toLowerCase();
    notifyListeners();
  }

  void clear() {
    textController.clear();
    _query = '';
    notifyListeners();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
