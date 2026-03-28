// features/sightings/presentation/extensions/gaming_platform_ui_extension.dart
import 'package:asa_server_eye/features/sightings/domain/player_sighting.dart';

extension GamingPlatformUiExtension on GamingPlatform {
  String get label {
    switch (this) {
      case GamingPlatform.steam:
        return 'Steam';
      case GamingPlatform.xbox:
        return 'Xbox';
      case GamingPlatform.psn:
        return 'PSN';
      case GamingPlatform.unknown:
        return 'Unbekannt';
    }
  }
}
