// features/alerts/presentation/screens/alerts_overview_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../domain/entities/alert_rule.dart';
import '../controllers/alert_rule_mutation_controller.dart';
import '../extensions/alert_settings_l10n.dart';
import '../providers/alert_rules_providers.dart';
import '../widgets/alert_rule_form_sheet.dart';
import '../widgets/alert_rule_list_tile.dart';
import '../widgets/alerts_message_body.dart';

class AlertsOverviewScreen extends ConsumerWidget {
  const AlertsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    final rulesAsync = ref.watch(userAlertRulesProvider);
    final mutationState = ref.watch(alertRuleMutationControllerProvider);
    final isMutating = mutationState.isLoading;
    final theme = Theme.of(context);

    ref.listen<AsyncValue<void>>(alertRuleMutationControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        error: (_, _) =>
            _showSnackBar(context, context.l10n.alertRuleMutationError),
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.alertsOverviewTitle)),
      body: userId == null
          ? AlertsMessageBody(message: context.l10n.alertRulesRequiresLogin)
          : AbsorbPointer(
              absorbing: isMutating,
              child: rulesAsync.when(
                data: (rules) {
                  if (rules.isEmpty) {
                    return AlertsMessageBody(
                      message: context.l10n.noUserAlertRulesYet,
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: rules.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final rule = rules[index];

                      return Dismissible(
                        key: ValueKey(rule.id),
                        direction: DismissDirection.endToStart,
                        background: _DeleteRuleSwipeBackground(
                          label: context.l10n.delete,
                        ),
                        confirmDismiss: (_) => _confirmDelete(
                          context: context,
                          ref: ref,
                          userId: userId,
                          rule: rule,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4,
                                bottom: 6,
                              ),
                              child: Text(
                                '${rule.serverName} • ${rule.mapName}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            AlertRuleListTile(
                              rule: rule,
                              onEdit: () => _openEditSheet(
                                context: context,
                                ref: ref,
                                userId: userId,
                                rule: rule,
                              ),
                              onDelete: () => _confirmDelete(
                                context: context,
                                ref: ref,
                                userId: userId,
                                rule: rule,
                              ),
                              onEnabledChanged: (value) => _setRuleEnabled(
                                context: context,
                                ref: ref,
                                userId: userId,
                                rule: rule,
                                isEnabled: value,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => AlertsMessageBody(
                  message: context.l10n.alertRulesLoadError,
                ),
              ),
            ),
    );
  }

  Future<void> _openEditSheet({
    required BuildContext context,
    required WidgetRef ref,
    required String userId,
    required AlertRule rule,
  }) async {
    final updatedRule = await showModalBottomSheet<AlertRule>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AlertRuleFormSheet(
        userId: userId,
        serverId: rule.serverId,
        serverName: rule.serverName,
        mapName: rule.mapName,
        existingRule: rule,
      ),
    );

    if (updatedRule == null || !context.mounted) return;

    await ref
        .read(alertRuleMutationControllerProvider.notifier)
        .updateRule(updatedRule);
    if (!context.mounted) return;

    if (_mutationWasSuccessful(ref)) {
      _showMutationSuccessSnackBar(
        context: context,
        message: context.l10n.alertRuleUpdated,
      );
    }
  }

  Future<void> _setRuleEnabled({
    required BuildContext context,
    required WidgetRef ref,
    required String userId,
    required AlertRule rule,
    required bool isEnabled,
  }) async {
    await ref
        .read(alertRuleMutationControllerProvider.notifier)
        .setRuleEnabled(userId: userId, ruleId: rule.id, isEnabled: isEnabled);
    if (!context.mounted) return;

    if (_mutationWasSuccessful(ref)) {
      _showMutationSuccessSnackBar(
        context: context,
        message: context.l10n.alertRuleUpdated,
      );
    }
  }

  Future<bool> _confirmDelete({
    required BuildContext context,
    required WidgetRef ref,
    required String userId,
    required AlertRule rule,
  }) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.deleteAlertRule),
          content: Text(context.l10n.deleteAlertRuleQuestion),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.l10n.delete),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted) return false;

    await ref
        .read(alertRuleMutationControllerProvider.notifier)
        .deleteRule(userId: userId, ruleId: rule.id);
    if (!context.mounted) return false;

    if (!_mutationWasSuccessful(ref)) return false;

    _showMutationSuccessSnackBar(
      context: context,
      message: context.l10n.alertRuleDeleted,
    );
    return true;
  }

  bool _mutationWasSuccessful(WidgetRef ref) {
    return !ref.read(alertRuleMutationControllerProvider).hasError;
  }

  void _showMutationSuccessSnackBar({
    required BuildContext context,
    required String message,
  }) {
    _showSnackBar(context, message);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _DeleteRuleSwipeBackground extends StatelessWidget {
  const _DeleteRuleSwipeBackground({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline, color: colorScheme.onErrorContainer),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
