import 'package:asa_server_eye/app/presentation/widgets/app_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../controllers/sign_in_controller.dart';
import '../utils/auth_feedback.dart';
import '../widgets/app_gradient_background.dart';
import '../widgets/auth_email_field.dart';
import '../widgets/auth_screen_header.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail.trim());
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _isSubmitting = true);

    final message = await ref
        .read(signInControllerProvider)
        .sendPasswordResetEmail(context: context, email: _emailController.text);

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    AuthFeedback.showMessage(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.resetPassword)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: AppGradientBackground(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AuthScreenHeader(
                  imagePath: 'assets/images/app_logo.png',
                  title: context.l10n.forgotPassword,
                  subtitle: context.l10n.resetPasswordInstructions,
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        AuthEmailField(
                          controller: _emailController,
                          labelText: context.l10n.email,
                          hintText: 'name@email.com',
                        ),
                        const SizedBox(height: 24),
                        AppActionButton(
                          label: context.l10n.sendResetLink,
                          isLoading: _isSubmitting,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: 8),
                        AppActionButton(
                          label: context.l10n.signIn,
                          isLoading: _isSubmitting,
                          variant: AppActionButtonVariant.secondary,
                          onPressed: () async => Navigator.of(context).pop(),
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
