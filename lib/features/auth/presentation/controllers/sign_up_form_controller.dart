// features/auth/presentation/controllers/sign_up_form_controller.dart
import 'package:flutter/material.dart';

import 'password_visibility_controller.dart';
import 'sign_up_controller.dart';

class SignUpFormController extends ChangeNotifier {
  SignUpFormController(this._authController);

  final SignUpController _authController;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  final passwordVisibilityController = PasswordVisibilityController();
  final repeatPasswordVisibilityController = PasswordVisibilityController();

  bool _isSubmitting = false;

  bool get isSubmitting => _isSubmitting;

  Future<String?> submit(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    _setSubmitting(true);

    try {
      return await _authController.signUp(
        context: context,
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        repeatPassword: repeatPasswordController.text,
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
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    passwordVisibilityController.dispose();
    repeatPasswordVisibilityController.dispose();
    super.dispose();
  }
}
