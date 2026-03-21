// features/servers/presentation/widgets/server_detail_row.dart
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class ServerDetailRow extends StatelessWidget {
  const ServerDetailRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
