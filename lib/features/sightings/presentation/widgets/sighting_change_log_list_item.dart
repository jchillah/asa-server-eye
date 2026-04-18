// features/sightings/presentation/widgets/sighting_change_log_list_item.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:asa_server_eye/core/extensions/date_time_formatting_extension.dart';
import 'package:flutter/material.dart';

import '../../domain/sighting_change_log.dart';
import '../extensions/sighting_change_action_l10n_extension.dart';

class SightingChangeLogListItem extends StatelessWidget {
  const SightingChangeLogListItem({super.key, required this.log});

  final SightingChangeLog log;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final changedAt = log.changedAt.toAppDateTime();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(log.action.label(context), style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(log.summary, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(changedAt, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              context.l10n.changedByLabel(log.changedByUserId),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
