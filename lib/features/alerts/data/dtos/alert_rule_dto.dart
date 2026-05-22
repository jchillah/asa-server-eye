// features/alerts/data/dtos/alert_rule_dto.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/alert_rule.dart';
import '../../domain/entities/alert_rule_type.dart';

class AlertRuleDto {
  const AlertRuleDto({
    required this.userId,
    required this.serverId,
    required this.serverName,
    required this.mapName,
    required this.ruleType,
    required this.isEnabled,
    required this.threshold,
    required this.createdAt,
    required this.updatedAt,
    required this.lastTriggeredAt,
  });

  final String userId;
  final String serverId;
  final String serverName;
  final String mapName;
  final String ruleType;
  final bool isEnabled;
  final int? threshold;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final Timestamp? lastTriggeredAt;

  factory AlertRuleDto.fromFirestore(Map<String, dynamic> json) {
    return AlertRuleDto(
      userId: json['userId'] as String? ?? '',
      serverId: json['serverId'] as String? ?? '',
      serverName: json['serverName'] as String? ?? '',
      mapName: json['mapName'] as String? ?? '',
      ruleType: json['ruleType'] as String? ?? '',
      isEnabled: json['isEnabled'] as bool? ?? true,
      threshold: json['threshold'] as int?,
      createdAt: json['createdAt'] as Timestamp?,
      updatedAt: json['updatedAt'] as Timestamp?,
      lastTriggeredAt: json['lastTriggeredAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'serverId': serverId,
      'serverName': serverName,
      'mapName': mapName,
      'ruleType': ruleType,
      'isEnabled': isEnabled,
      'threshold': threshold,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastTriggeredAt': lastTriggeredAt,
    };
  }

  AlertRule toDomain(String id) {
    return AlertRule(
      id: id,
      userId: userId,
      serverId: serverId,
      serverName: serverName,
      mapName: mapName,
      ruleType: AlertRuleTypeX.fromFirestore(ruleType),
      isEnabled: isEnabled,
      threshold: threshold,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastTriggeredAt: lastTriggeredAt,
    );
  }

  static AlertRuleDto fromDomain(AlertRule rule) {
    return AlertRuleDto(
      userId: rule.userId,
      serverId: rule.serverId,
      serverName: rule.serverName,
      mapName: rule.mapName,
      ruleType: rule.ruleType.firestoreValue,
      isEnabled: rule.isEnabled,
      threshold: rule.threshold,
      createdAt: rule.createdAt,
      updatedAt: rule.updatedAt,
      lastTriggeredAt: rule.lastTriggeredAt,
    );
  }
}
