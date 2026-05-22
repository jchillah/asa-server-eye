// app/presentation/app_shell.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/alerts/presentation/screens/alerts_overview_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/servers/presentation/screens/server_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/sightings/domain/sightings_access_level.dart';
import '../../features/sightings/presentation/providers/sightings_access_providers.dart';
import '../../features/sightings/presentation/screens/sightings_overview_screen.dart';
import 'controllers/app_shell_controller.dart';
import 'widgets/app_bottom_navigation_bar.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(appShellIndexProvider);
    final accessLevelAsync = ref.watch(sightingsAccessLevelProvider);

    return accessLevelAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.accessLevelLoadError,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(sightingsAccessLevelProvider),
                  child: Text(context.l10n.apply),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (accessLevel) {
        final hasPremiumAccess =
            accessLevel == SightingsAccessLevel.premium ||
            accessLevel == SightingsAccessLevel.admin;
        final includeAlerts = hasPremiumAccess;
        final includeSightings = hasPremiumAccess;

        final screens = <Widget>[
          const ServerListScreen(),
          const FavoritesScreen(),
          if (includeAlerts) const AlertsOverviewScreen(),
          if (includeSightings) const SightingsOverviewScreen(),
          const SettingsScreen(),
        ];

        final safeIndex = currentIndex.clamp(0, screens.length - 1);

        if (safeIndex != currentIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(appShellIndexProvider.notifier).setIndex(safeIndex);
          });
        }

        return Scaffold(
          body: IndexedStack(index: safeIndex, children: screens),
          bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: safeIndex,
            includeAlerts: includeAlerts,
            includeSightings: includeSightings,
            onDestinationSelected: ref
                .read(appShellIndexProvider.notifier)
                .setIndex,
          ),
        );
      },
    );
  }
}
