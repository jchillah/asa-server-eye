// features/settings/presentation/screens/about_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.about)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          context.l10n.appInformation,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
