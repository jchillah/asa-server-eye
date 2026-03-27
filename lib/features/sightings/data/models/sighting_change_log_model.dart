// features/sightings/data/models/sighting_change_log_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/sighting_change_log.dart';

class SightingChangeLogModel extends SightingChangeLog {
  const SightingChangeLogModel({
    required super.id,
    required super.sightingId,
    required super.action,
    required super.changedAt,
    required super.changedByUserId,
    required super.summary,
    super.beforeData,
    super.afterData,
  });

  factory SightingChangeLogModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final json = doc.data() ?? <String, dynamic>{};

    return SightingChangeLogModel(
      id: doc.id,
      sightingId: json['sightingId']?.toString() ?? '',
      action: _actionFromString(json['action']),
      changedAt: _dateTimeFromFirestore(json['changedAt']),
      changedByUserId: json['changedByUserId']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      beforeData: _mapFromDynamic(json['beforeData']),
      afterData: _mapFromDynamic(json['afterData']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sightingId': sightingId,
      'action': action.name,
      'changedAt': Timestamp.fromDate(changedAt),
      'changedByUserId': changedByUserId,
      'summary': summary,
      'beforeData': beforeData,
      'afterData': afterData,
    };
  }

  static SightingChangeAction _actionFromString(dynamic value) {
    final normalized = value?.toString().trim().toLowerCase();

    switch (normalized) {
      case 'updated':
        return SightingChangeAction.updated;
      case 'softdeleted':
      case 'soft_deleted':
        return SightingChangeAction.softDeleted;
      default:
        return SightingChangeAction.created;
    }
  }

  static DateTime _dateTimeFromFirestore(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  static Map<String, dynamic>? _mapFromDynamic(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }
}
