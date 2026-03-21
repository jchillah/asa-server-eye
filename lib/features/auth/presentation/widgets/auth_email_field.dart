// features/auth/presentation/widgets/auth_email_field.dart
import 'package:flutter/material.dart';

class AuthEmailField extends StatelessWidget {
  const AuthEmailField({
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
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: const Icon(Icons.mail_outline_rounded),
      ),
    );
  }
}
