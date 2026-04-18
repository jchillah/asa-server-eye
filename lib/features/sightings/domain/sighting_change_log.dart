// features/sightings/domain/sighting_change_log.dart
enum SightingChangeAction { created, updated, softDeleted }

class SightingChangeLog {
  const SightingChangeLog({
    required this.id,
    required this.sightingId,
    required this.action,
    required this.changedAt,
    required this.changedByUserId,
    required this.summary,
    this.beforeData,
    this.afterData,
  });

  final String id;
  final String sightingId;
  final SightingChangeAction action;
  final DateTime changedAt;
  final String changedByUserId;
  final String summary;
  final Map<String, dynamic>? beforeData;
  final Map<String, dynamic>? afterData;
}
