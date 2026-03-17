// features/settings/presentation/screens/imprint_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';

class ImprintScreen extends StatelessWidget {
  const ImprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.imprint)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(context.l10n.legalInformation),
      ),
    );
  }
}
