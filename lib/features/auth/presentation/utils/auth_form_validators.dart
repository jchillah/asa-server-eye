// features/auth/presentation/utils/auth_form_validators.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';

abstract final class AuthFormValidators {
  static String? validateEmail(BuildContext context, String email) {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      return context.l10n.authMissingEmailOrPassword;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(trimmedEmail)) {
      return context.l10n.authInvalidEmailFormat;
    }

    return null;
  }

  static String? validatePasswordForSignIn(
    BuildContext context,
    String password,
  ) {
    if (password.isEmpty) {
      return context.l10n.authMissingEmailOrPassword;
    }

    return null;
  }

  static String? validatePasswordForSignUp(
    BuildContext context,
    String password,
  ) {
    if (password.isEmpty) {
      return context.l10n.authMissingEmailOrPassword;
    }

    if (password.length < 6) {
      return context.l10n.authWeakPassword;
    }

    return null;
  }

  static String? validateRepeatPassword(
    BuildContext context,
    String password,
    String repeatPassword,
  ) {
    if (repeatPassword.isEmpty) {
      return context.l10n.authMissingEmailOrPassword;
    }

    if (password != repeatPassword) {
      return context.l10n.passwordsDoNotMatch;
    }

    return null;
  }
}
