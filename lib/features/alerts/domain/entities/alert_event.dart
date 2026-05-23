// features/alerts/domain/entities/alert_event.dart
import 'alert_rule_type.dart';

class AlertEvent {
  const AlertEvent({
    required this.id,
    required this.userId,
    required this.ruleId,
    required this.serverId,
    required this.serverName,
    required this.mapName,
    required this.ruleType,
    required this.title,
    required this.createdAt,
    required this.triggeredAt,
    this.previousPlayers,
    this.currentPlayers,
    this.readAt,
  });

  final String id;
  final String userId;
  final String ruleId;
  final String serverId;
  final String serverName;
  final String mapName;
  final AlertRuleType ruleType;
  final String title;
  final int? previousPlayers;
  final int? currentPlayers;
  final DateTime? createdAt;
  final DateTime? triggeredAt;
  final DateTime? readAt;

  bool get isRead => readAt != null;
}
