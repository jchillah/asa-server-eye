// features/auth/presentation/screens/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../controllers/sign_up_form_controller.dart';
import '../utils/auth_feedback.dart';
import '../utils/auth_navigation.dart';
import '../widgets/auth_email_field.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_screen_header.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(signUpFormControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.signUp)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AuthScreenHeader(
              imagePath: 'assets/images/app_logo.png',
              title: context.l10n.createYourAccount,
              subtitle: context.l10n.signUpToSaveFavorites,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AuthEmailField(
                      controller: formController.emailController,
                      labelText: context.l10n.email,
                      hintText: 'name@email.com',
                    ),
                    const SizedBox(height: 16),
                    AuthPasswordField(
                      controller: formController.passwordController,
                      visibilityController:
                          formController.passwordVisibilityController,
                      labelText: context.l10n.password,
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    const SizedBox(height: 16),
                    AuthPasswordField(
                      controller: formController.repeatPasswordController,
                      visibilityController:
                          formController.repeatPasswordVisibilityController,
                      labelText: context.l10n.repeatPassword,
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: formController.isSubmitting
                          ? null
                          : () async {
                              final message = await formController.submit(
                                context,
                              );

                              if (!context.mounted) return;

                              if (message != null) {
                                AuthFeedback.showMessage(context, message);
                                return;
                              }

                              AuthNavigation.close(context);
                            },
                      child: formController.isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(context.l10n.signUp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
