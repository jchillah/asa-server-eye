// features/sightings/domain/sightings_sharing_policy.dart
import 'sighting_sharing_scope.dart';
import 'sightings_access_level.dart';

abstract final class SightingSharingPolicy {
  static SightingSharingScope resolve({
    required SightingsAccessLevel accessLevel,
    required bool shareWithPremiumUsers,
  }) {
    switch (accessLevel) {
      case SightingsAccessLevel.free:
        return SightingSharingScope.ownerOnly;

      case SightingsAccessLevel.premium:
        return shareWithPremiumUsers
            ? SightingSharingScope.premiumShared
            : SightingSharingScope.ownerOnly;

      case SightingsAccessLevel.admin:
        return SightingSharingScope.adminOnly;
    }
  }
}
