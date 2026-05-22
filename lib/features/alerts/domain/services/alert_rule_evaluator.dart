// features/alerts/domain/services/alert_rule_evaluator.dart
import '../../../servers/domain/server.dart';
import '../entities/alert_rule.dart';
import '../entities/alert_rule_type.dart';
import '../entities/alert_trigger_event.dart';

class AlertRuleEvaluator {
  const AlertRuleEvaluator({
    this.minimumTriggerInterval = const Duration(minutes: 1),
  });

  final Duration minimumTriggerInterval;

  List<AlertTriggerEvent> evaluate({
    required List<AlertRule> rules,
    required List<Server> previousServers,
    required List<Server> currentServers,
    required DateTime now,
  }) {
    if (rules.isEmpty || (previousServers.isEmpty && currentServers.isEmpty)) {
      return const [];
    }

    final previousById = _serversById(previousServers);
    final currentById = _serversById(currentServers);
    final events = <AlertTriggerEvent>[];

    for (final rule in rules) {
      if (!rule.isEnabled || _isWithinCooldown(rule, now)) {
        continue;
      }

      final previous = previousById[rule.serverId];
      final current = currentById[rule.serverId];

      if (!_shouldTrigger(rule: rule, previous: previous, current: current)) {
        continue;
      }

      events.add(
        AlertTriggerEvent(
          rule: rule,
          previousPlayers: previous?.players,
          currentPlayers: current?.players,
          triggeredAt: now,
        ),
      );
    }

    return events;
  }

  Map<String, Server> _serversById(List<Server> servers) {
    return {
      for (final server in servers) server.id: server,
    };
  }

  bool _isWithinCooldown(AlertRule rule, DateTime now) {
    final lastTriggeredAt = rule.lastTriggeredAt;
    if (lastTriggeredAt == null) {
      return false;
    }

    return now.difference(lastTriggeredAt.toUtc()) < minimumTriggerInterval;
  }

  bool _shouldTrigger({
    required AlertRule rule,
    required Server? previous,
    required Server? current,
  }) {
    switch (rule.ruleType) {
      case AlertRuleType.populationIncreased:
        return previous != null &&
            current != null &&
            current.players > previous.players;
      case AlertRuleType.populationDecreased:
        return previous != null &&
            current != null &&
            current.players < previous.players;
      case AlertRuleType.crossedAboveThreshold:
        final threshold = rule.threshold;
        if (threshold == null || previous == null || current == null) {
          return false;
        }
        return previous.players <= threshold && current.players > threshold;
      case AlertRuleType.crossedBelowThreshold:
        final threshold = rule.threshold;
        if (threshold == null || previous == null || current == null) {
          return false;
        }
        return previous.players >= threshold && current.players < threshold;
      case AlertRuleType.serverOnline:
        return previous == null && current != null;
      case AlertRuleType.serverOffline:
        return previous != null && current == null;
    }
  }
}
