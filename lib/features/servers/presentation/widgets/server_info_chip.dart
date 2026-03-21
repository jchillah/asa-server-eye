// features/servers/presentation/widgets/server_info_chip.dart
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class ServerInfoChip extends StatelessWidget {
  const ServerInfoChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
