// features/auth/presentation/screens/sign_up_screen.dart
import 'package:asa_server_eye/app/presentation/widgets/app_action_button.dart';
import 'package:asa_server_eye/features/auth/presentation/providers/sign_up_form_controller_provider.dart';
import 'package:asa_server_eye/features/auth/presentation/widgets/app_gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../utils/auth_feedback.dart';
import '../utils/auth_navigation.dart';
import '../widgets/auth_email_field.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_screen_header.dart';
import '../widgets/auth_username_field.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(signUpFormControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.signUp)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: AppGradientBackground(
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
                        AuthUsernameField(
                          controller: formController.usernameController,
                          labelText: context.l10n.username,
                          hintText: context.l10n.signUpUsernameHint,
                        ),
                        const SizedBox(height: 16),
                        AuthEmailField(
                          controller: formController.emailController,
                          labelText: context.l10n.email,
                          hintText: context.l10n.emailHint,
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
                        AppActionButton(
                          label: context.l10n.signUp,
                          isLoading: formController.isSubmitting,
                          onPressed: () async {
                            final message = await formController.submit(
                              context,
                            );

                            if (!context.mounted) return;

                            if (message != null) {
                              AuthFeedback.showMessage(context, message);
                              return;
                            }

                            AuthFeedback.showMessage(
                              context,
                              context.l10n.accountCreated,
                            );

                            AuthNavigation.close(context);
                          },
                        ),
                        const SizedBox(height: 8),
                        AppActionButton(
                          label: context.l10n.signIn,
                          isLoading: formController.isSubmitting,
                          variant: AppActionButtonVariant.secondary,
                          onPressed: () async {
                            AuthNavigation.close(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
