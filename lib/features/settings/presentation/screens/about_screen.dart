// features/settings/presentation/screens/about_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../widgets/simple_info_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleInfoScreen(
      title: context.l10n.about,
      body: context.l10n.appInformation,
    );
  }
}
