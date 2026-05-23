// features/alerts/data/dtos/alert_event_dto.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/alert_event.dart';
import '../../domain/entities/alert_rule_type.dart';

class AlertEventDto {
  const AlertEventDto({
    required this.userId,
    required this.ruleId,
    required this.serverId,
    required this.serverName,
    required this.mapName,
    required this.ruleType,
    required this.title,
    required this.previousPlayers,
    required this.currentPlayers,
    required this.createdAt,
    required this.triggeredAt,
    required this.readAt,
  });

  final String userId;
  final String ruleId;
  final String serverId;
  final String serverName;
  final String mapName;
  final String ruleType;
  final String title;
  final int? previousPlayers;
  final int? currentPlayers;
  final Timestamp? createdAt;
  final Timestamp? triggeredAt;
  final Timestamp? readAt;

  factory AlertEventDto.fromFirestore(Map<String, dynamic> json) {
    return AlertEventDto(
      userId: _readString(json, 'userId'),
      ruleId: _readString(json, 'ruleId'),
      serverId: _readString(json, 'serverId'),
      serverName: _readString(json, 'serverName'),
      mapName: _readString(json, 'mapName'),
      ruleType: _readString(json, 'ruleType'),
      title: _readString(json, 'title'),
      previousPlayers: _readNullableInt(json['previousPlayers']),
      currentPlayers: _readNullableInt(json['currentPlayers']),
      createdAt: _readTimestamp(json['createdAt']),
      triggeredAt: _readTimestamp(json['triggeredAt']),
      readAt: _readTimestamp(json['readAt']),
    );
  }

  AlertEvent toDomain(String id) {
    final parsedRuleType = AlertRuleTypeX.tryFromFirestore(ruleType);
    if (parsedRuleType == null) {
      throw StateError('AlertEventDto.toDomain: unknown ruleType "$ruleType"');
    }

    return AlertEvent(
      id: id,
      userId: userId,
      ruleId: ruleId,
      serverId: serverId,
      serverName: serverName,
      mapName: mapName,
      ruleType: parsedRuleType,
      title: title,
      previousPlayers: previousPlayers,
      currentPlayers: currentPlayers,
      createdAt: createdAt?.toDate(),
      triggeredAt: triggeredAt?.toDate(),
      readAt: readAt?.toDate(),
    );
  }

  static String _readString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw StateError('AlertEventDto.fromFirestore: invalid "$key"');
    }
    return value;
  }

  static int? _readNullableInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw StateError('AlertEventDto.fromFirestore: invalid int "$value"');
  }

  static Timestamp? _readTimestamp(Object? value) {
    if (value == null) return null;
    if (value is Timestamp) return value;
    throw StateError('AlertEventDto.fromFirestore: invalid timestamp "$value"');
  }
}
