// features/sightings/domain/sightings_visibility_mapper.dart
import 'player_sighting.dart';
import 'sightings_access_level.dart';

abstract final class SightingsVisibilityMapper {
  static SightingVisibilityLevel creationVisibilityForAccessLevel(
    SightingsAccessLevel accessLevel,
  ) {
    switch (accessLevel) {
      case SightingsAccessLevel.free:
        return SightingVisibilityLevel.free;
      case SightingsAccessLevel.premium:
        return SightingVisibilityLevel.premium;
      case SightingsAccessLevel.admin:
        return SightingVisibilityLevel.admin;
    }
  }

  static SightingSharingScope creationSharingScopeForAccessLevel({
    required SightingsAccessLevel accessLevel,
    required bool shareWithPremiumUsers,
  }) {
    switch (accessLevel) {
      case SightingsAccessLevel.free:
        return SightingSharingScope.premiumShared;
      case SightingsAccessLevel.premium:
        return shareWithPremiumUsers
            ? SightingSharingScope.premiumShared
            : SightingSharingScope.ownerOnly;
      case SightingsAccessLevel.admin:
        return SightingSharingScope.ownerOnly;
    }
  }
}
