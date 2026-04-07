// features/sightings/domain/sighting_creator_level_policy.dart
import 'sighting_creator_level.dart';
import 'sightings_access_level.dart';

abstract final class SightingCreatorLevelPolicy {
  static SightingCreatorLevel resolve({
    required SightingsAccessLevel accessLevel,
  }) {
    switch (accessLevel) {
      case SightingsAccessLevel.free:
        return SightingCreatorLevel.free;
      case SightingsAccessLevel.premium:
        return SightingCreatorLevel.premium;
      case SightingsAccessLevel.admin:
        return SightingCreatorLevel.admin;
    }
  }
}
