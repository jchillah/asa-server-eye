// features/auth/presentation/utils/auth_form_validators.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';

abstract final class AuthFormValidators {
  static String? validateUsername(BuildContext context, String username) {
    final trimmedUsername = username.trim();

    if (trimmedUsername.isEmpty) {
      return 'Bitte gib einen Benutzernamen ein.';
    }

    if (trimmedUsername.length < 3) {
      return 'Der Benutzername muss mindestens 3 Zeichen lang sein.';
    }

    if (trimmedUsername.length > 20) {
      return 'Der Benutzername darf maximal 20 Zeichen lang sein.';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9._-]+$');
    if (!usernameRegex.hasMatch(trimmedUsername)) {
      return 'Der Benutzername darf nur Buchstaben, Zahlen, Punkt, Unterstrich und Bindestrich enthalten.';
    }

    return null;
  }

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
