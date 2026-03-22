// features/settings/presentation/screens/privacy_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../utils/support_actions.dart';
import '../widgets/simple_info_screen.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleInfoScreen(
      title: context.l10n.privacyPolicy,
      body: context.l10n.privacyBody,
      bottom: Column(
        children: [
          const SizedBox(height: 24),
          FilledButton(
            onPressed: SupportActions.openPrivacyPolicy,
            child: Text(context.l10n.fullPrivacyPolicy),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: SupportActions.openDeleteAccount,
            child: Text(context.l10n.deleteAccount),
          ),
        ],
      ),
    );
  }
}
