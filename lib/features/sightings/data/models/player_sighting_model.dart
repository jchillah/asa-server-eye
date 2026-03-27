// features/sightings/data/models/player_sighting_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/player_sighting.dart';

class PlayerSightingModel extends PlayerSighting {
  const PlayerSightingModel({
    required super.id,
    required super.serverId,
    required super.playerName,
    required super.playerId,
    required super.platform,
    required super.createdAt,
    required super.createdByUserId,
    required super.visibilityLevel,
    required super.sharingScope,
    required super.isVisible,
    super.note,
    super.updatedAt,
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
      playerName: json['playerName']?.toString() ?? '',
      playerId: json['playerId']?.toString() ?? '',
      platform: _platformFromString(json['platform']),
      createdAt: _dateTimeFromFirestore(json['createdAt']),
      createdByUserId: json['createdByUserId']?.toString() ?? '',
      visibilityLevel: _visibilityFromString(json['visibilityLevel']),
      sharingScope: _sharingScopeFromString(json['sharingScope']),
      isVisible: json['isVisible'] == true,
      note: json['note']?.toString(),
      updatedAt: _nullableDateTimeFromFirestore(json['updatedAt']),
      deletedAt: _nullableDateTimeFromFirestore(json['deletedAt']),
      deletedByUserId: json['deletedByUserId']?.toString(),
      deleteReason: json['deleteReason']?.toString(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'serverId': serverId,
      'playerName': playerName,
      'playerId': playerId,
      'platform': platform.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdByUserId': createdByUserId,
      'visibilityLevel': visibilityLevel.name,
      'sharingScope': sharingScope.name,
      'isVisible': isVisible,
      'note': note,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'deletedAt': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
      'deletedByUserId': deletedByUserId,
      'deleteReason': deleteReason,
    };
  }

  PlayerSightingModel copyWith({
    String? id,
    String? serverId,
    String? playerName,
    String? playerId,
    GamingPlatform? platform,
    DateTime? createdAt,
    String? createdByUserId,
    SightingVisibilityLevel? visibilityLevel,
    SightingSharingScope? sharingScope,
    bool? isVisible,
    String? note,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? deletedByUserId,
    String? deleteReason,
  }) {
    return PlayerSightingModel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      playerName: playerName ?? this.playerName,
      playerId: playerId ?? this.playerId,
      platform: platform ?? this.platform,
      createdAt: createdAt ?? this.createdAt,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      visibilityLevel: visibilityLevel ?? this.visibilityLevel,
      sharingScope: sharingScope ?? this.sharingScope,
      isVisible: isVisible ?? this.isVisible,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
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

  static SightingVisibilityLevel _visibilityFromString(dynamic value) {
    final normalized = value?.toString().trim().toLowerCase();

    switch (normalized) {
      case 'premium':
        return SightingVisibilityLevel.premium;
      case 'admin':
        return SightingVisibilityLevel.admin;
      default:
        return SightingVisibilityLevel.free;
    }
  }

  static SightingSharingScope _sharingScopeFromString(dynamic value) {
    final normalized = value?.toString().trim().toLowerCase();

    switch (normalized) {
      case 'premiumshared':
      case 'premium_shared':
        return SightingSharingScope.premiumShared;
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
