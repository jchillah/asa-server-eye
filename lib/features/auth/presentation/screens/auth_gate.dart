// features/auth/presentation/screens/auth_gate.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/presentation/app_shell.dart';
import '../../../../core/extensions/context_l10n.dart';
import '../providers/auth_providers.dart';
import 'sign_in_screen.dart';

const _authGateLogTag = 'AuthGate';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);

    return authStateAsync.when(
      data: (user) {
        if (user == null) {
          return const SignInScreen();
        }

        return const AppShell();
      },
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            semanticsLabel: context.l10n.loading,
          ),
        ),
      ),
      error: (error, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: _authGateLogTag,
            context: ErrorDescription(
              'authStateProvider stream error in AuthGate',
            ),
          ),
        );

        if (kDebugMode) {
          debugPrint('$_authGateLogTag error: $error');
          debugPrintStack(stackTrace: stackTrace);
        }

        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(context.l10n.genericError),
            ),
          ),
        );
      },
    );
  }
}
