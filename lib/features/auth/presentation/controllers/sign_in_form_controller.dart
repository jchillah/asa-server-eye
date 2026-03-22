// features/auth/presentation/controllers/sign_in_form_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'password_visibility_controller.dart';
import 'sign_in_controller.dart';

final signInFormControllerProvider =
    ChangeNotifierProvider.autoDispose<SignInFormController>((ref) {
      final authController = ref.watch(signInControllerProvider);
      return SignInFormController(authController);
    });

class SignInFormController extends ChangeNotifier {
  SignInFormController(this._authController);

  final SignInController _authController;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordVisibilityController = PasswordVisibilityController();

  bool _isSubmitting = false;

  bool get isSubmitting => _isSubmitting;

  Future<String?> submit(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    _setSubmitting(true);

    try {
      return await _authController.signIn(
        context: context,
        email: emailController.text,
        password: passwordController.text,
      );
    } finally {
      _setSubmitting(false);
    }
  }

  void _setSubmitting(bool value) {
    if (_isSubmitting == value) return;
    _isSubmitting = value;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordVisibilityController.dispose();
    super.dispose();
  }
}
