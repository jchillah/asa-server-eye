// features/alerts/domain/entities/alert_rule.dart
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

  static const Object _unset = Object();

  final String id;
  final String userId;
  final String serverId;
  final String serverName;
  final String mapName;
  final AlertRuleType ruleType;
  final bool isEnabled;
  final int? threshold;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastTriggeredAt;

  AlertRule copyWith({
    String? id,
    String? userId,
    String? serverId,
    String? serverName,
    String? mapName,
    AlertRuleType? ruleType,
    bool? isEnabled,
    Object? threshold = _unset,
    Object? createdAt = _unset,
    Object? updatedAt = _unset,
    Object? lastTriggeredAt = _unset,
  }) {
    return AlertRule(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serverId: serverId ?? this.serverId,
      serverName: serverName ?? this.serverName,
      mapName: mapName ?? this.mapName,
      ruleType: ruleType ?? this.ruleType,
      isEnabled: isEnabled ?? this.isEnabled,
      threshold: identical(threshold, _unset)
          ? this.threshold
          : threshold as int?,
      createdAt: identical(createdAt, _unset)
          ? this.createdAt
          : createdAt as DateTime?,
      updatedAt: identical(updatedAt, _unset)
          ? this.updatedAt
          : updatedAt as DateTime?,
      lastTriggeredAt: identical(lastTriggeredAt, _unset)
          ? this.lastTriggeredAt
          : lastTriggeredAt as DateTime?,
    );
  }

  bool get requiresThreshold =>
      ruleType == AlertRuleType.crossedAboveThreshold ||
      ruleType == AlertRuleType.crossedBelowThreshold;
}
