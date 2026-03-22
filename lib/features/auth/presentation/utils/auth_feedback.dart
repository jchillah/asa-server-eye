// features/auth/presentation/utils/auth_feedback.dart
import 'package:flutter/material.dart';

abstract final class AuthFeedback {
  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
