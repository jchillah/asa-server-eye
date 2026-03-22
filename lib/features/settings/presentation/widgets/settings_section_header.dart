// features/settings/presentation/widgets/settings_section_header.dart
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: AppColors.neonGreen),
      ),
    );
  }
}
