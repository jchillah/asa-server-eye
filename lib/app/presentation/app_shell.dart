// app/presentation/app_shell.dart
import 'dart:async';

import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/alerts/domain/entities/alert_trigger_event.dart';
import '../../features/alerts/presentation/controllers/alert_evaluation_controller.dart';
import '../../features/alerts/presentation/extensions/alert_rule_type_l10n.dart';
import '../../features/alerts/presentation/providers/alert_rules_providers.dart';
import '../../features/alerts/presentation/screens/alerts_overview_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/notifications/presentation/controllers/fcm_token_registration_controller.dart';
import '../../features/notifications/presentation/services/local_alert_notification_service.dart';
import '../../features/servers/presentation/providers/servers_provider.dart';
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
    ref.watch(fcmTokenRegistrationControllerProvider);

    final currentIndex = ref.watch(appShellIndexProvider);
    final accessLevelAsync = ref.watch(sightingsAccessLevelProvider);
    final localNotificationService = ref.watch(
      localAlertNotificationServiceProvider,
    );

    ref.listen(serverSyncStateProvider, (previous, next) {
      final syncState = next.valueOrNull;
      final rules = ref.read(userAlertRulesProvider).valueOrNull;

      if (syncState == null || rules == null) {
        return;
      }

      ref
          .read(alertEvaluationControllerProvider.notifier)
          .evaluateServerRefresh(
            rules: rules,
            currentServers: syncState.servers,
          );
    });

    ref.listen<AlertTriggerEvent?>(alertEvaluationControllerProvider, (
      previous,
      next,
    ) {
      if (next == null || next == previous || !context.mounted) {
        return;
      }

      final message = _alertEventMessage(context, next);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      unawaited(
        localNotificationService.showAlertNotification(
          title: next.rule.ruleType.localizedLabel(context),
          body: message,
          serverId: next.rule.serverId,
        ),
      );
    });

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

  String _alertEventMessage(BuildContext context, AlertTriggerEvent event) {
    final previousPlayers = event.previousPlayers;
    final currentPlayers = event.currentPlayers;
    final populationChange = previousPlayers == null || currentPlayers == null
        ? ''
        : ' ($previousPlayers → $currentPlayers)';

    return '${event.rule.ruleType.localizedLabel(context)}: '
        '${event.serverName} • ${event.mapName}$populationChange';
  }
}
