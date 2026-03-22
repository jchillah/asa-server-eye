// features/auth/presentation/widgets/auth_password_field.dart
import 'package:flutter/material.dart';

import '../controllers/password_visibility_controller.dart';

class AuthPasswordField extends StatelessWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.visibilityController,
    required this.labelText,
    this.autofillHints = const [AutofillHints.password],
  });

  final TextEditingController controller;
  final PasswordVisibilityController visibilityController;
  final String labelText;
  final Iterable<String> autofillHints;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: visibilityController,
      builder: (context, _) {
        return TextField(
          controller: controller,
          obscureText: visibilityController.obscureText,
          autofillHints: autofillHints,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              onPressed: visibilityController.toggle,
              icon: Icon(
                visibilityController.obscureText
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
              ),
            ),
          ),
        );
      },
    );
  }
}
