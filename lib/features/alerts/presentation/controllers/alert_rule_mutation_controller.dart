// features/alerts/presentation/providers/alert_rule_mutation_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/alert_rule.dart';
import '../providers/alert_rules_providers.dart';

final alertRuleMutationControllerProvider =
    AutoDisposeAsyncNotifierProvider<AlertRuleMutationController, void>(
      AlertRuleMutationController.new,
    );

class AlertRuleMutationController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createRule(AlertRule rule) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(alertRulesRepositoryProvider).createRule(rule);
    });
  }

  Future<void> updateRule(AlertRule rule) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(alertRulesRepositoryProvider).updateRule(rule);
    });
  }

  Future<void> deleteRule({
    required String userId,
    required String ruleId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(alertRulesRepositoryProvider)
          .deleteRule(userId: userId, ruleId: ruleId);
    });
  }

  Future<void> deleteRulesForServer({
    required String userId,
    required String serverId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(alertRulesRepositoryProvider)
          .deleteRulesForServer(userId: userId, serverId: serverId);
    });
  }

  Future<void> setRuleEnabled({
    required String userId,
    required String ruleId,
    required bool isEnabled,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(alertRulesRepositoryProvider)
          .setRuleEnabled(userId: userId, ruleId: ruleId, isEnabled: isEnabled);
    });
  }
}
