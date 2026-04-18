// features/sightings/presentation/extensions/gaming_platform_l10n_extension.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../domain/gaming_platform.dart';

extension GamingPlatformL10nExtension on GamingPlatform {
  String label(BuildContext context) {
    switch (this) {
      case GamingPlatform.steam:
        return context.l10n.platformSteam;
      case GamingPlatform.xbox:
        return context.l10n.platformXbox;
      case GamingPlatform.psn:
        return context.l10n.platformPsn;
      case GamingPlatform.unknown:
        return context.l10n.platformUnknown;
    }
  }
}
