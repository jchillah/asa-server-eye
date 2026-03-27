// features/sightings/domain/sightings_visibility_policy.dart
import 'player_sighting.dart';
import 'sightings_access_level.dart';

abstract final class SightingsVisibilityPolicy {
  static bool canAccess({
    required PlayerSighting sighting,
    required SightingsAccessLevel accessLevel,
    required String? currentUserId,
  }) {
    switch (accessLevel) {
      case SightingsAccessLevel.free:
        return currentUserId != null &&
            sighting.createdByUserId == currentUserId &&
            sighting.isVisible;

      case SightingsAccessLevel.premium:
        return sighting.isVisible &&
            (sighting.createdByUserId == currentUserId ||
                sighting.sharingScope == SightingSharingScope.premiumShared);

      case SightingsAccessLevel.admin:
        return true;
    }
  }

  static List<PlayerSighting> filterSightings({
    required List<PlayerSighting> sightings,
    required SightingsAccessLevel accessLevel,
    required String? currentUserId,
  }) {
    return sightings
        .where(
          (sighting) => canAccess(
            sighting: sighting,
            accessLevel: accessLevel,
            currentUserId: currentUserId,
          ),
        )
        .toList(growable: false);
  }
}
