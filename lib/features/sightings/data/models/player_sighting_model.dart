// features/sightings/data/models/player_sighting_model.dart
import 'package:asa_server_eye/features/sightings/domain/gaming_platform.dart';
import 'package:asa_server_eye/features/sightings/domain/sighting_creator_level.dart';
import 'package:asa_server_eye/features/sightings/domain/sighting_sharing_scope.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/player_sighting.dart';

class PlayerSightingModel extends PlayerSighting {
  const PlayerSightingModel({
    required super.id,
    required super.serverId,
    required super.inGameName,
    required super.playerPlatformId,
    required super.tribeName,
    required super.platform,
    required super.createdAt,
    required super.createdByUserId,
    required super.createdByUsername,
    required super.createdByEmail,
    required super.creatorLevel,
    required super.sharingScope,
    required super.isVisible,
    super.note,
    super.updatedAt,
    super.updatedByUserId,
    super.deletedAt,
    super.deletedByUserId,
    super.deleteReason,
  });

  factory PlayerSightingModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final json = doc.data() ?? <String, dynamic>{};

    return PlayerSightingModel(
      id: doc.id,
      serverId: json['serverId']?.toString() ?? '',
      inGameName: json['inGameName']?.toString() ?? '',
      playerPlatformId: json['playerPlatformId']?.toString() ?? '',
      tribeName: json['tribeName']?.toString() ?? '',
      platform: _platformFromString(json['platform']),
      createdAt: _dateTimeFromFirestore(json['createdAt']),
      createdByUserId: json['createdByUserId']?.toString() ?? '',
      createdByUsername: json['createdByUsername']?.toString() ?? '',
      createdByEmail: json['createdByEmail']?.toString() ?? '',
      creatorLevel: _creatorLevelFromString(json['creatorLevel']),
      sharingScope: _sharingScopeFromString(json['sharingScope']),
      isVisible: json['isVisible'] == true,
      note: json['note']?.toString(),
      updatedAt: _nullableDateTimeFromFirestore(json['updatedAt']),
      updatedByUserId: json['updatedByUserId']?.toString(),
      deletedAt: _nullableDateTimeFromFirestore(json['deletedAt']),
      deletedByUserId: json['deletedByUserId']?.toString(),
      deleteReason: json['deleteReason']?.toString(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'serverId': serverId,
      'inGameName': inGameName,
      'playerPlatformId': playerPlatformId,
      'tribeName': tribeName,
      'platform': platform.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdByUserId': createdByUserId,
      'createdByUsername': createdByUsername,
      'createdByEmail': createdByEmail,
      'creatorLevel': creatorLevel.name,
      'sharingScope': sharingScope.name,
      'isVisible': isVisible,
      'note': note,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'updatedByUserId': updatedByUserId,
      'deletedAt': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
      'deletedByUserId': deletedByUserId,
      'deleteReason': deleteReason,
    };
  }

  PlayerSightingModel copyWith({
    String? id,
    String? serverId,
    String? inGameName,
    String? playerPlatformId,
    String? tribeName,
    GamingPlatform? platform,
    DateTime? createdAt,
    String? createdByUserId,
    String? createdByUsername,
    String? createdByEmail,
    SightingCreatorLevel? creatorLevel,
    SightingSharingScope? sharingScope,
    bool? isVisible,
    String? note,
    DateTime? updatedAt,
    String? updatedByUserId,
    DateTime? deletedAt,
    String? deletedByUserId,
    String? deleteReason,
  }) {
    return PlayerSightingModel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      inGameName: inGameName ?? this.inGameName,
      playerPlatformId: playerPlatformId ?? this.playerPlatformId,
      tribeName: tribeName ?? this.tribeName,
      platform: platform ?? this.platform,
      createdAt: createdAt ?? this.createdAt,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdByUsername: createdByUsername ?? this.createdByUsername,
      createdByEmail: createdByEmail ?? this.createdByEmail,
      creatorLevel: creatorLevel ?? this.creatorLevel,
      sharingScope: sharingScope ?? this.sharingScope,
      isVisible: isVisible ?? this.isVisible,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedByUserId: updatedByUserId ?? this.updatedByUserId,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedByUserId: deletedByUserId ?? this.deletedByUserId,
      deleteReason: deleteReason ?? this.deleteReason,
    );
  }

  static GamingPlatform _platformFromString(dynamic value) {
    final normalized = value?.toString().trim().toLowerCase();

    switch (normalized) {
      case 'steam':
        return GamingPlatform.steam;
      case 'xbox':
        return GamingPlatform.xbox;
      case 'psn':
        return GamingPlatform.psn;
      default:
        return GamingPlatform.unknown;
    }
  }

  static SightingCreatorLevel _creatorLevelFromString(dynamic value) {
    final normalized = value?.toString().trim().toLowerCase();

    switch (normalized) {
      case 'premium':
        return SightingCreatorLevel.premium;
      case 'admin':
        return SightingCreatorLevel.admin;
      default:
        return SightingCreatorLevel.free;
    }
  }

  static SightingSharingScope _sharingScopeFromString(dynamic value) {
    final normalized = value?.toString().trim().toLowerCase();

    switch (normalized) {
      case 'premiumshared':
      case 'premium_shared':
        return SightingSharingScope.premiumShared;
      case 'adminonly':
      case 'admin_only':
        return SightingSharingScope.adminOnly;
      default:
        return SightingSharingScope.ownerOnly;
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

  static DateTime? _nullableDateTimeFromFirestore(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
