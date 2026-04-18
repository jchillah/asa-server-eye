// features/sightings/presentation/extensions/sighting_sharing_scope_ui_extension.dart
import 'package:asa_server_eye/features/sightings/domain/sighting_sharing_scope.dart';

extension SightingSharingScopeUiExtension on SightingSharingScope {
  String get label {
    switch (this) {
      case SightingSharingScope.ownerOnly:
        return 'Nur für den Ersteller sichtbar';
      case SightingSharingScope.premiumShared:
        return 'Für Premium-User sichtbar';
      case SightingSharingScope.adminOnly:
        return 'Nur für Admins sichtbar';
    }
  }
}
