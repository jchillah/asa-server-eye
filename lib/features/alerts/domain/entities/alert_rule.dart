// features/alerts/domain/entities/alert_rule.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import 'alert_rule_type.dart';

class AlertRule {
  const AlertRule({
    required this.id,
    required this.userId,
    required this.serverId,
    required this.serverName,
    required this.mapName,
    required this.ruleType,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
    this.threshold,
    this.lastTriggeredAt,
  });

  final String id;
  final String userId;
  final String serverId;
  final String serverName;
  final String mapName;
  final AlertRuleType ruleType;
  final bool isEnabled;
  final int? threshold;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final Timestamp? lastTriggeredAt;

  AlertRule copyWith({
    String? id,
    String? userId,
    String? serverId,
    String? serverName,
    String? mapName,
    AlertRuleType? ruleType,
    bool? isEnabled,
    int? threshold,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    Timestamp? lastTriggeredAt,
  }) {
    return AlertRule(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serverId: serverId ?? this.serverId,
      serverName: serverName ?? this.serverName,
      mapName: mapName ?? this.mapName,
      ruleType: ruleType ?? this.ruleType,
      isEnabled: isEnabled ?? this.isEnabled,
      threshold: threshold ?? this.threshold,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastTriggeredAt: lastTriggeredAt ?? this.lastTriggeredAt,
    );
  }

  bool get requiresThreshold =>
      ruleType == AlertRuleType.crossedAboveThreshold ||
      ruleType == AlertRuleType.crossedBelowThreshold;
}
