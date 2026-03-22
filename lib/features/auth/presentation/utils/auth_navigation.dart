// features/auth/presentation/utils/auth_navigation.dart
import 'package:flutter/material.dart';

import '../screens/sign_up_screen.dart';

abstract final class AuthNavigation {
  static Future<void> openSignUp(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignUpScreen()));
  }

  static void close(BuildContext context) {
    Navigator.of(context).pop();
  }
}
