// features/alerts/presentation/controllers/alert_evaluation_controller.dart
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../servers/domain/server.dart';
import '../../domain/entities/alert_rule.dart';
import '../../domain/entities/alert_trigger_event.dart';
import '../../domain/repositories/alert_rules_repository.dart';
import '../../domain/services/alert_rule_evaluator.dart';
import '../providers/alert_rules_providers.dart';

final alertRuleEvaluatorProvider = Provider<AlertRuleEvaluator>((ref) {
  return const AlertRuleEvaluator();
});

final alertEvaluationControllerProvider =
    StateNotifierProvider.autoDispose<
      AlertEvaluationController,
      AlertTriggerEvent?
    >((ref) {
      final repository = ref.watch(alertRulesRepositoryProvider);
      final evaluator = ref.watch(alertRuleEvaluatorProvider);

      return AlertEvaluationController(
        repository: repository,
        evaluator: evaluator,
      );
    });

class AlertEvaluationController extends StateNotifier<AlertTriggerEvent?> {
  AlertEvaluationController({
    required AlertRulesRepository repository,
    required AlertRuleEvaluator evaluator,
  }) : _repository = repository,
       _evaluator = evaluator,
       super(null);

  final AlertRulesRepository _repository;
  final AlertRuleEvaluator _evaluator;

  List<Server>? _previousServers;
  bool _isPersistingTriggers = false;

  Future<void> evaluateServerRefresh({
    required List<AlertRule> rules,
    required List<Server> currentServers,
  }) async {
    final previousServers = _previousServers;
    _previousServers = currentServers;

    if (previousServers == null || rules.isEmpty || _isPersistingTriggers) {
      return;
    }

    final now = DateTime.now().toUtc();
    final events = _evaluator.evaluate(
      rules: rules,
      previousServers: previousServers,
      currentServers: currentServers,
      now: now,
    );

    if (events.isEmpty) {
      return;
    }

    state = events.first;

    _isPersistingTriggers = true;
    try {
      for (final event in events) {
        await _repository.markRuleTriggered(
          userId: event.rule.userId,
          ruleId: event.rule.id,
        );
      }
    } catch (error, stackTrace) {
      developer.log(
        'Failed to mark alert rules as triggered.',
        name: 'AlertEvaluationController',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      _isPersistingTriggers = false;
    }
  }
}
