// features/servers/presentation/controllers/server_search_controller.dart
import 'package:flutter/material.dart';

class ServerSearchController extends ChangeNotifier {
  ServerSearchController();

  final TextEditingController textController = TextEditingController();

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
