// features/profile/presentation/utils/profile_feedback.dart
import 'package:flutter/material.dart';

abstract final class ProfileFeedback {
  static void showMessage(BuildContext context, String message) {
    if (message.trim().isEmpty) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
