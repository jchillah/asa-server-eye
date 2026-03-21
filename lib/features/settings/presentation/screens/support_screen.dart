// features/settings/presentation/screens/support_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../utils/support_actions.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.support)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SelectableText(
            context.l10n.supportBody,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => SupportActions.sendSupportEmail(context),
            icon: const Icon(Icons.email_outlined),
            label: Text(context.l10n.contactSupport),
          ),
        ],
      ),
    );
  }
}
