// features/sightings/presentation/extensions/sighting_change_action_ui_extension.dart
import 'package:asa_server_eye/features/sightings/domain/sighting_change_log.dart';

extension SightingChangeActionUiExtension on SightingChangeAction {
  String get label {
    switch (this) {
      case SightingChangeAction.created:
        return 'Erstellt';
      case SightingChangeAction.updated:
        return 'Bearbeitet';
      case SightingChangeAction.softDeleted:
        return 'Ausgeblendet';
    }
  }
}
