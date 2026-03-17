// features/settings/presentation/screens/support_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../widgets/simple_info_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleInfoScreen(
      title: context.l10n.support,
      body: context.l10n.getHelpAndContactSupport,
    );
  }
}
