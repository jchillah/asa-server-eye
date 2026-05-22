// features/alerts/domain/repositories/alert_rules_repository.dart
import 'package:asa_server_eye/features/alerts/domain/entities/alert_rule.dart';

abstract class AlertRulesRepository {
  Stream<List<AlertRule>> watchRules(String userId);

  Stream<List<AlertRule>> watchRulesForServer({
    required String userId,
    required String serverId,
  });

  Future<void> createRule(AlertRule rule);

  Future<void> updateRule(AlertRule rule);

  Future<void> deleteRule({required String userId, required String ruleId});

  Future<void> setRuleEnabled({
    required String userId,
    required String ruleId,
    required bool isEnabled,
  });
}
