// features/sightings/presentation/widgets/sighting_change_log_list_item.dart
import 'package:flutter/material.dart';

import '../../domain/sighting_change_log.dart';

class SightingChangeLogListItem extends StatelessWidget {
  const SightingChangeLogListItem({super.key, required this.log});

  final SightingChangeLog log;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_actionLabel(log.action), style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(log.summary, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              _formatDateTime(log.changedAt),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Changed by: ${log.changedByUserId}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _actionLabel(SightingChangeAction action) {
    switch (action) {
      case SightingChangeAction.created:
        return 'Created';
      case SightingChangeAction.updated:
        return 'Updated';
      case SightingChangeAction.softDeleted:
        return 'Soft Deleted';
    }
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$day.$month.$year  $hour:$minute';
  }
}
