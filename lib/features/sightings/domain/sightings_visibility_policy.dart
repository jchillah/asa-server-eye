// features/sightings/domain/sightings_visibility_policy.dart
import 'package:asa_server_eye/features/sightings/domain/player_sighting.dart';
import 'package:asa_server_eye/features/sightings/domain/sighting_sharing_scope.dart';
import 'package:asa_server_eye/features/sightings/domain/sightings_access_level.dart';

abstract final class SightingsVisibilityPolicy {
  static bool canRead({
    required PlayerSighting sighting,
    required SightingsAccessLevel accessLevel,
    required String? currentUserId,
  }) {
    if (accessLevel == SightingsAccessLevel.admin) {
      return true;
    }

    if (currentUserId != null && sighting.createdByUserId == currentUserId) {
      return true;
    }

    if (!sighting.isVisible) {
      return false;
    }

    switch (sighting.sharingScope) {
      case SightingSharingScope.ownerOnly:
        return false;
      case SightingSharingScope.premiumShared:
        return accessLevel == SightingsAccessLevel.premium;
      case SightingSharingScope.adminOnly:
        return false;
    }
  }

  static List<PlayerSighting> filterSightings({
    required List<PlayerSighting> sightings,
    required SightingsAccessLevel accessLevel,
    required String? currentUserId,
  }) {
    return sightings
        .where(
          (sighting) => canRead(
            sighting: sighting,
            accessLevel: accessLevel,
            currentUserId: currentUserId,
          ),
        )
        .toList(growable: false);
  }
}
