// features/sightings/presentation/utils/sightings_message_mapper.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';

abstract final class SightingsMessageMapper {
  static String? map(BuildContext context, String? key) {
    switch (key) {
      case 'sightingInGameNameRequired':
        return context.l10n.sightingInGameNameRequired;
      case 'sightingPlatformIdRequired':
        return context.l10n.sightingPlatformIdRequired;
      case 'sightingTribeNameRequired':
        return context.l10n.sightingTribeNameRequired;
      case 'sightingRequiresLogin':
        return context.l10n.sightingRequiresLogin;
      case 'sightingUserProfileLoadError':
        return context.l10n.sightingUserProfileLoadError;
      case 'sightingSaveError':
        return context.l10n.sightingSaveError;
      case 'sightingEditNotAllowed':
        return context.l10n.sightingEditNotAllowed;
      case 'sightingUpdateError':
        return context.l10n.sightingUpdateError;
      case 'sightingDeleteNotAllowed':
        return context.l10n.sightingDeleteNotAllowed;
      case 'sightingReasonRequired':
        return context.l10n.sightingReasonRequired;
      case 'sightingHideError':
        return context.l10n.sightingHideError;
      default:
        return null;
    }
  }
}
