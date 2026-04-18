// features/sightings/presentation/extensions/sighting_creator_level_ui_extension.dart
import 'package:asa_server_eye/features/sightings/domain/sighting_creator_level.dart';

extension SightingCreatorLevelUiExtension on SightingCreatorLevel {
  String get label {
    switch (this) {
      case SightingCreatorLevel.free:
        return 'Free User';
      case SightingCreatorLevel.premium:
        return 'Premium User';
      case SightingCreatorLevel.admin:
        return 'Admin';
    }
  }
}
