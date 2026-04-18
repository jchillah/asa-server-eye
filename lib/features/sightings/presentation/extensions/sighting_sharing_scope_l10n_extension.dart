// features/sightings/presentation/extensions/sighting_sharing_scope_l10n_extension.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../domain/sighting_sharing_scope.dart';

extension SightingSharingScopeL10nExtension on SightingSharingScope {
  String label(BuildContext context) {
    switch (this) {
      case SightingSharingScope.ownerOnly:
        return context.l10n.sightingSharingOwnerOnly;
      case SightingSharingScope.premiumShared:
        return context.l10n.sightingSharingPremiumShared;
      case SightingSharingScope.adminOnly:
        return context.l10n.sightingSharingAdminOnly;
    }
  }
}
