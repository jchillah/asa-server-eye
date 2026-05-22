// features/alerts/domain/entities/alert_trigger_event.dart
import 'alert_rule.dart';

class AlertTriggerEvent {
  const AlertTriggerEvent({
    required this.rule,
    required this.previousPlayers,
    required this.currentPlayers,
    required this.triggeredAt,
  });

  final AlertRule rule;
  final int? previousPlayers;
  final int? currentPlayers;
  final DateTime triggeredAt;

  String get serverName => rule.serverName;
  String get mapName => rule.mapName;
}
