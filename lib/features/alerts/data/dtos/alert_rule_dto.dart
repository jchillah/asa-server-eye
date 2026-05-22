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
      userId: _requireNonEmptyString(json, 'userId'),
      serverId: _requireNonEmptyString(json, 'serverId'),
      serverName: _requireNonEmptyString(json, 'serverName'),
      mapName: _requireNonEmptyString(json, 'mapName'),
      ruleType: _requireNonEmptyString(json, 'ruleType'),
      isEnabled: _requireBool(json, 'isEnabled'),
      threshold: _parseThreshold(json['threshold']),
      createdAt: _readTimestamp(json, 'createdAt'),
      updatedAt: _readTimestamp(json, 'updatedAt'),
      lastTriggeredAt: _readTimestamp(json, 'lastTriggeredAt'),
    );
  }

  static String _requireNonEmptyString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw StateError('AlertRuleDto.fromFirestore: invalid or missing "$key"');
    }
    return value;
  }

  static bool _requireBool(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! bool) {
      throw StateError('AlertRuleDto.fromFirestore: invalid or missing "$key"');
    }
    return value;
  }

  static int? _parseThreshold(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    throw StateError(
      'AlertRuleDto.fromFirestore: invalid "threshold" value: $value',
    );
  }

  static Timestamp? _readTimestamp(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) {
      return null;
    }
    if (value is Timestamp) {
      return value;
    }
    throw StateError(
      'AlertRuleDto.fromFirestore: invalid "$key" value: $value',
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
    final parsedRuleType = AlertRuleTypeX.tryFromFirestore(ruleType);
    if (parsedRuleType == null) {
      throw StateError('AlertRuleDto.toDomain: unknown ruleType "$ruleType"');
    }

    return AlertRule(
      id: id,
      userId: userId,
      serverId: serverId,
      serverName: serverName,
      mapName: mapName,
      ruleType: parsedRuleType,
      isEnabled: isEnabled,
      threshold: threshold,
      createdAt: createdAt?.toDate(),
      updatedAt: updatedAt?.toDate(),
      lastTriggeredAt: lastTriggeredAt?.toDate(),
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
      createdAt: rule.createdAt == null
          ? null
          : Timestamp.fromDate(rule.createdAt!),
      updatedAt: rule.updatedAt == null
          ? null
          : Timestamp.fromDate(rule.updatedAt!),
      lastTriggeredAt: rule.lastTriggeredAt == null
          ? null
          : Timestamp.fromDate(rule.lastTriggeredAt!),
    );
  }
}
