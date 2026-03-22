// features/auth/presentation/controllers/sign_up_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../data/auth_repository.dart';
import '../providers/auth_providers.dart';
import '../utils/auth_error_mapper.dart';
import '../utils/auth_form_validators.dart';

final signUpControllerProvider = Provider<SignUpController>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpController(repository);
});

class SignUpController {
  const SignUpController(this._repository);

  final AuthRepository _repository;

  Future<String?> signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String repeatPassword,
  }) async {
    final l10n = context.l10n;

    final emailError = AuthFormValidators.validateEmail(context, email);
    if (emailError != null) {
      return emailError;
    }

    final passwordError = AuthFormValidators.validatePasswordForSignUp(
      context,
      password,
    );
    if (passwordError != null) {
      return passwordError;
    }

    final repeatPasswordError = AuthFormValidators.validateRepeatPassword(
      context,
      password,
      repeatPassword,
    );
    if (repeatPasswordError != null) {
      return repeatPasswordError;
    }

    try {
      await _repository.signUp(email: email.trim(), password: password);
      return null;
    } on FirebaseAuthException catch (error) {
      return AuthErrorMapper.mapSignUpError(
        code: error.code,
        invalidEmailFormat: l10n.authInvalidEmailFormat,
        emailAlreadyInUse: l10n.authEmailAlreadyInUse,
        weakPassword: l10n.authWeakPassword,
        networkError: l10n.networkError,
        genericError: l10n.genericError,
      );
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e, stack) {
      debugPrint('🔥 AUTH ERROR: $e');
      debugPrintStack(stackTrace: stack);
      return l10n.genericError;
    }
  }
}
