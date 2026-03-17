// features/settings/presentation/screens/privacy_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.privacyPolicy)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.l10n.privacyPolicy,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(context.l10n.howDataIsHandled, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.l10n.howDataIsHandled,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
