// features/sightings/presentation/extensions/sighting_creator_level_l10n_extension.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../domain/sighting_creator_level.dart';

extension SightingCreatorLevelL10nExtension on SightingCreatorLevel {
  String label(BuildContext context) {
    switch (this) {
      case SightingCreatorLevel.free:
        return context.l10n.sightingCreatorLevelFree;
      case SightingCreatorLevel.premium:
        return context.l10n.sightingCreatorLevelPremium;
      case SightingCreatorLevel.admin:
        return context.l10n.sightingCreatorLevelAdmin;
    }
  }
}
