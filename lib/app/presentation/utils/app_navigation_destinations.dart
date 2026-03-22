// app/presentation/utils/app_navigation_destinations.dart
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../models/app_navigation_destination_item.dart';

abstract final class AppNavigationDestinations {
  static List<AppNavigationDestinationItem> fromL10n(AppLocalizations l10n) {
    return [
      AppNavigationDestinationItem(
        icon: Icons.dns_outlined,
        selectedIcon: Icons.dns,
        label: l10n.servers,
      ),
      AppNavigationDestinationItem(
        icon: Icons.star_border_rounded,
        selectedIcon: Icons.star_rounded,
        label: l10n.favorites,
      ),
      AppNavigationDestinationItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        label: l10n.settings,
      ),
    ];
  }
}
