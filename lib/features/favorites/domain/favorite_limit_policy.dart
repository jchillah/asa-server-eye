// features/favorites/domain/favorite_limit_policy.dart
import 'package:asa_server_eye/features/sightings/domain/sightings_access_level.dart';

abstract final class FavoriteLimitPolicy {
  static int maxFavoritesFor(SightingsAccessLevel accessLevel) {
    switch (accessLevel) {
      case SightingsAccessLevel.free:
        return 1;
      case SightingsAccessLevel.premium:
        return 50;
      case SightingsAccessLevel.admin:
        return 200;
    }
  }
}
