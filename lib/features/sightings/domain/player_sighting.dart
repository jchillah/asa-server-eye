// features/sightings/domain/player_sighting.dart
import 'package:asa_server_eye/features/sightings/domain/gaming_platform.dart';
import 'package:asa_server_eye/features/sightings/domain/sighting_creator_level.dart';
import 'package:asa_server_eye/features/sightings/domain/sighting_sharing_scope.dart';

class PlayerSighting {
  const PlayerSighting({
    required this.id,
    required this.serverId,
    required this.playerPlatformId,
    required this.inGameName,
    required this.tribeName,
    required this.platform,
    required this.createdAt,
    required this.createdByUserId,
    required this.createdByUsername,
    required this.createdByEmail,
    required this.creatorLevel,
    required this.sharingScope,
    required this.isVisible,
    this.note,
    this.updatedAt,
    this.updatedByUserId,
    this.deletedAt,
    this.deletedByUserId,
    this.deleteReason,
  });

  final String id;
  final String serverId;
  final String playerPlatformId;
  final String inGameName;
  final String tribeName;
  final GamingPlatform platform;
  final DateTime createdAt;
  final String createdByUserId;
  final String createdByUsername;
  final String createdByEmail;
  final SightingCreatorLevel creatorLevel;
  final SightingSharingScope sharingScope;
  final bool isVisible;
  final String? note;
  final DateTime? updatedAt;
  final String? updatedByUserId;
  final DateTime? deletedAt;
  final String? deletedByUserId;
  final String? deleteReason;

  bool get isDeleted => !isVisible && deletedAt != null;
}
