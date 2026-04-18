// features/auth/presentation/widgets/auth_username_field.dart
import 'package:flutter/material.dart';

class AuthUsernameField extends StatelessWidget {
  const AuthUsernameField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: const Icon(Icons.person_outline_rounded),
      ),
    );
  }
}
