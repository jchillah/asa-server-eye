// features/auth/presentation/screens/sign_in_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../providers/auth_providers.dart';
import 'sign_up_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.authMissingEmailOrPassword)),
      );
      return;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.authInvalidEmailFormat)),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final repository = ref.read(authRepositoryProvider);

      await repository.signIn(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;

      late final String message;

      switch (error.code) {
        case 'invalid-email':
          message = context.l10n.authInvalidEmailFormat;
          break;
        case 'user-disabled':
          message = context.l10n.authUserDisabled;
          break;
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          message = context.l10n.authInvalidCredentials;
          break;
        case 'network-request-failed':
          message = context.l10n.networkError;
          break;
        default:
          message = context.l10n.genericError;
          break;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.genericError)));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.signIn)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(context.l10n.welcomeBack, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(context.l10n.signInToContinue, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              labelText: context.l10n.email,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              labelText: context.l10n.password,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isSubmitting ? null : _signIn,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(context.l10n.signIn),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _isSubmitting
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  },
            child: Text(context.l10n.createAccount),
          ),
        ],
      ),
    );
  }
}
