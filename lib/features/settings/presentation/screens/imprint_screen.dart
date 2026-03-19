// features/settings/presentation/screens/imprint_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../widgets/simple_info_screen.dart';

class ImprintScreen extends StatelessWidget {
  const ImprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleInfoScreen(
      title: context.l10n.imprint,
      body: context.l10n.imprintBody,
    );
  }
}
