// features/sightings/domain/player_sighting.dart
enum SightingVisibilityLevel { free, premium, admin }

enum GamingPlatform { steam, xbox, psn, unknown }

enum SightingSharingScope { ownerOnly, premiumShared }

class PlayerSighting {
  const PlayerSighting({
    required this.id,
    required this.serverId,
    required this.playerName,
    required this.playerId,
    required this.platform,
    required this.createdAt,
    required this.createdByUserId,
    required this.visibilityLevel,
    required this.sharingScope,
    required this.isVisible,
    this.note,
    this.updatedAt,
    this.deletedAt,
    this.deletedByUserId,
    this.deleteReason,
  });

  final String id;
  final String serverId;
  final String playerName;
  final String playerId;
  final GamingPlatform platform;
  final DateTime createdAt;
  final String createdByUserId;
  final SightingVisibilityLevel visibilityLevel;
  final SightingSharingScope sharingScope;
  final bool isVisible;
  final String? note;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? deletedByUserId;
  final String? deleteReason;
}
