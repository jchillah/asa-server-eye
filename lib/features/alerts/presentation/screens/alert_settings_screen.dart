// features/alerts/presentation/screens/alert_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../domain/entities/alert_rule.dart';
import '../controllers/alert_rule_mutation_controller.dart';
import '../providers/alert_rules_providers.dart';
import '../widgets/alert_rule_form_sheet.dart';
import '../widgets/alert_rule_list_tile.dart';

class AlertSettingsScreen extends ConsumerWidget {
  const AlertSettingsScreen({
    super.key,
    required this.serverId,
    required this.serverName,
    required this.mapName,
  });
  final String serverId;
  final String serverName;
  final String mapName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    final rulesAsync = ref.watch(serverAlertRulesProvider(serverId));
    final mutationState = ref.watch(alertRuleMutationControllerProvider);
    final isMutating = mutationState.isLoading;
    final theme = Theme.of(context);
    ref.listen<AsyncValue<void>>(alertRuleMutationControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        error: (_, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.alertRuleMutationError)),
          );
        },
      );
    });
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.alertSettingsTitle)),
      floatingActionButton: userId == null
          ? null
          : FloatingActionButton.extended(
              onPressed: isMutating
                  ? null
                  : () => _openCreateSheet(
                      context: context,
                      ref: ref,
                      userId: userId,
                    ),
              icon: const Icon(Icons.add),
              label: Text(context.l10n.addAlertRule),
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              '$serverName • $mapName',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          if (userId == null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    context.l10n.alertRulesRequiresLogin,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: AbsorbPointer(
                absorbing: isMutating,
                child: rulesAsync.when(
                  data: (rules) {
                    if (rules.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            context.l10n.noAlertRulesYet,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: rules.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final rule = rules[index];
                        return AlertRuleListTile(
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
                          onEnabledChanged: (value) async {
                            await ref
                                .read(
                                  alertRuleMutationControllerProvider.notifier,
                                )
                                .setRuleEnabled(
                                  userId: userId,
                                  ruleId: rule.id,
                                  isEnabled: value,
                                );
                            if (!context.mounted) return;
                            final state = ref.read(
                              alertRuleMutationControllerProvider,
                            );
                            if (!state.hasError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.l10n.alertRuleUpdated),
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        context.l10n.alertRulesLoadError,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openCreateSheet({
    required BuildContext context,
    required WidgetRef ref,
    required String userId,
  }) async {
    final rule = await showModalBottomSheet<AlertRule>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AlertRuleFormSheet(
        userId: userId,
        serverId: serverId,
        serverName: serverName,
        mapName: mapName,
      ),
    );
    if (rule == null || !context.mounted) return;
    await ref
        .read(alertRuleMutationControllerProvider.notifier)
        .createRule(rule);
    if (!context.mounted) return;
    final state = ref.read(alertRuleMutationControllerProvider);
    if (!state.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.alertRuleSaved)));
    }
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
        serverId: serverId,
        serverName: serverName,
        mapName: mapName,
        existingRule: rule,
      ),
    );
    if (updatedRule == null || !context.mounted) return;
    await ref
        .read(alertRuleMutationControllerProvider.notifier)
        .updateRule(updatedRule);
    if (!context.mounted) return;
    final state = ref.read(alertRuleMutationControllerProvider);
    if (!state.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.alertRuleUpdated)));
    }
  }

  Future<void> _confirmDelete({
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
    if (shouldDelete != true || !context.mounted) return;
    await ref
        .read(alertRuleMutationControllerProvider.notifier)
        .deleteRule(userId: userId, ruleId: rule.id);
    if (!context.mounted) return;
    final state = ref.read(alertRuleMutationControllerProvider);
    if (!state.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.alertRuleDeleted)));
    }
  }
}
