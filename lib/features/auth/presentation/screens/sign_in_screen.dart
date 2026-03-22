// features/auth/presentation/screens/sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../controllers/sign_in_form_controller.dart';
import '../utils/auth_feedback.dart';
import '../utils/auth_navigation.dart';
import '../widgets/auth_email_field.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_screen_header.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formController = ref.watch(signInFormControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.signIn)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AuthScreenHeader(
              imagePath: 'assets/images/app_logo.png',
              title: context.l10n.welcomeBack,
              subtitle: context.l10n.signInToContinue,
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
                      autofillHints: const [AutofillHints.password],
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: formController.isSubmitting
                          ? null
                          : () async {
                              final message = await formController.submit(
                                context,
                              );

                              if (!context.mounted || message == null) return;
                              AuthFeedback.showMessage(context, message);
                            },
                      child: formController.isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(context.l10n.signIn),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: formController.isSubmitting
                          ? null
                          : () => AuthNavigation.openSignUp(context),
                      child: Text(context.l10n.createAccount),
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
