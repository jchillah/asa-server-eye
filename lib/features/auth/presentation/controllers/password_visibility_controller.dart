// features/auth/presentation/controllers/password_visibility_controller.dart
import 'package:flutter/foundation.dart';

class PasswordVisibilityController extends ChangeNotifier {
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  void toggle() {
    _obscureText = !_obscureText;
    notifyListeners();
  }
}
