// features/alerts/presentation/widgets/alert_event_list_tile.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../domain/entities/alert_event.dart';
import '../extensions/alert_rule_type_l10n.dart';
import '../extensions/alert_settings_l10n.dart';

class AlertEventListTile extends StatelessWidget {
  const AlertEventListTile({
    required this.event,
    required this.onDelete,
    required this.onDeleteServerHistory,
    super.key,
  });

  final AlertEvent event;
  final VoidCallback onDelete;
  final VoidCallback onDeleteServerHistory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final triggeredAt = event.triggeredAt ?? event.createdAt;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: const Icon(Icons.notifications_active_outlined),
        ),
        title: Text(event.ruleType.localizedLabel(context)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${event.serverName} • ${event.mapName}'),
              if (_populationChangeText() != null) ...[
                const SizedBox(height: 2),
                Text(_populationChangeText()!),
              ],
              if (triggeredAt != null) ...[
                const SizedBox(height: 2),
                Text(
                  MaterialLocalizations.of(context).formatShortDate(
                    triggeredAt,
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        trailing: PopupMenuButton<_AlertEventAction>(
          onSelected: (action) {
            switch (action) {
              case _AlertEventAction.delete:
                onDelete();
              case _AlertEventAction.deleteServerHistory:
                onDeleteServerHistory();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _AlertEventAction.delete,
              child: Text(context.l10n.delete),
            ),
            PopupMenuItem(
              value: _AlertEventAction.deleteServerHistory,
              child: Text(context.l10n.deleteServerAlertEvents),
            ),
          ],
        ),
      ),
    );
  }

  String? _populationChangeText() {
    final previous = event.previousPlayers;
    final current = event.currentPlayers;

    if (previous == null && current == null) {
      return null;
    }

    if (previous == null) {
      return '$current players';
    }

    if (current == null) {
      return '$previous players';
    }

    return '$previous → $current players';
  }
}

enum _AlertEventAction { delete, deleteServerHistory }
