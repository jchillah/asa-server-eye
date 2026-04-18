// app/presentation/widgets/app_bottom_navigation_bar.dart
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../utils/app_navigation_destinations.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.includeSightings,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool includeSightings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final destinations = AppNavigationDestinations.fromL10n(
      l10n,
      includeSightings: includeSightings,
    );

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations
          .map(
            (item) => NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: item.label,
            ),
          )
          .toList(),
    );
  }
}
