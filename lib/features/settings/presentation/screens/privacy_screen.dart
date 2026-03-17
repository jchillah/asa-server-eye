// features/settings/presentation/screens/privacy_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.privacyPolicy)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(context.l10n.howDataIsHandled),
      ),
    );
  }
}
