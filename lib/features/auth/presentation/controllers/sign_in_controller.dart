// features/auth/presentation/controllers/sign_in_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../../../core/utils/app_logger.dart';
import '../../data/auth_repository.dart';
import '../providers/auth_providers.dart';
import '../utils/auth_error_mapper.dart';
import '../utils/auth_form_validators.dart';

final signInControllerProvider = Provider<SignInController>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInController(repository);
});

class SignInController {
  const SignInController(this._repository);

  final AuthRepository _repository;

  Future<String?> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final l10n = context.l10n;

    final emailError = AuthFormValidators.validateEmail(context, email);
    if (emailError != null) {
      return emailError;
    }

    final passwordError = AuthFormValidators.validatePasswordForSignIn(
      context,
      password,
    );
    if (passwordError != null) {
      return passwordError;
    }

    try {
      await _repository.signIn(email: email.trim(), password: password);
      return null;
    } on FirebaseAuthException catch (error, stackTrace) {
      AppLogger.warning(
        'SignInController',
        'FirebaseAuthException during sign-in: ${error.code}',
      );

      AppLogger.error(
        'SignInController',
        'Sign-in failed with FirebaseAuthException.',
        error: error,
        stackTrace: stackTrace,
      );

      return AuthErrorMapper.mapSignInError(
        code: error.code,
        invalidEmailFormat: l10n.authInvalidEmailFormat,
        userDisabled: l10n.authUserDisabled,
        invalidCredentials: l10n.authInvalidCredentials,
        networkError: l10n.networkError,
        genericError: l10n.genericError,
      );
    } on FirebaseException catch (error, stackTrace) {
      AppLogger.error(
        'SignInController',
        'Sign-in failed with FirebaseException.',
        error: error,
        stackTrace: stackTrace,
      );

      return error.message ?? l10n.genericError;
    } catch (error, stackTrace) {
      AppLogger.error(
        'SignInController',
        'Unexpected sign-in error.',
        error: error,
        stackTrace: stackTrace,
      );

      return l10n.genericError;
    }
  }
}
