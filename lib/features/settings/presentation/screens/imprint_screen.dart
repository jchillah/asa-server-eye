// features/settings/presentation/screens/imprint_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';

class ImprintScreen extends StatelessWidget {
  const ImprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.imprint)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(context.l10n.imprint, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(context.l10n.legalInformation, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.l10n.legalInformation,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
