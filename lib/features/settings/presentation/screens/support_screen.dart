// features/settings/presentation/screens/support_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.support)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(context.l10n.getHelpAndContactSupport),
      ),
    );
  }
}
