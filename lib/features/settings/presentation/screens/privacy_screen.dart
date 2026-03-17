// features/settings/presentation/screens/privacy_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../widgets/simple_info_screen.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleInfoScreen(
      title: context.l10n.privacyPolicy,
      body: context.l10n.privacyBody,
    );
  }
}
