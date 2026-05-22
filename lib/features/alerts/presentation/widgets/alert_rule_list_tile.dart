// features/alerts/presentation/widgets/alert_rule_list_tile.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../domain/entities/alert_rule.dart';
import '../../domain/entities/alert_rule_type.dart';

class AlertRuleListTile extends StatelessWidget {
  const AlertRuleListTile({
    super.key,
    required this.rule,
    required this.onEdit,
    required this.onDelete,
    required this.onEnabledChanged,
  });
  final AlertRule rule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onEnabledChanged;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _ruleTypeLabel(context, rule.ruleType),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Switch.adaptive(
                  value: rule.isEnabled,
                  onChanged: onEnabledChanged,
                ),
              ],
            ),
            if (rule.threshold != null) ...[
              const SizedBox(height: 4),
              Text(
                '${context.l10n.alertRuleThreshold}: ${rule.threshold}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(context.l10n.edit),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: Text(context.l10n.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _ruleTypeLabel(BuildContext context, AlertRuleType type) {
    switch (type) {
      case AlertRuleType.populationIncreased:
        return context.l10n.alertTypePopulationIncreased;
      case AlertRuleType.populationDecreased:
        return context.l10n.alertTypePopulationDecreased;
      case AlertRuleType.crossedAboveThreshold:
        return context.l10n.alertTypeCrossedAboveThreshold;
      case AlertRuleType.crossedBelowThreshold:
        return context.l10n.alertTypeCrossedBelowThreshold;
      case AlertRuleType.serverOnline:
        return context.l10n.alertTypeServerOnline;
      case AlertRuleType.serverOffline:
        return context.l10n.alertTypeServerOffline;
    }
  }
}
