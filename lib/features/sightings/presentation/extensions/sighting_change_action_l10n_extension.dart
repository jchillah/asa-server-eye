// features/sightings/presentation/extensions/sighting_change_action_l10n_extension.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../domain/sighting_change_log.dart';

extension SightingChangeActionL10nExtension on SightingChangeAction {
  String label(BuildContext context) {
    switch (this) {
      case SightingChangeAction.created:
        return context.l10n.sightingActionCreated;
      case SightingChangeAction.updated:
        return context.l10n.sightingActionUpdated;
      case SightingChangeAction.softDeleted:
        return context.l10n.sightingActionSoftDeleted;
    }
  }
}
