// features/servers/presentation/screens/server_detail_screen.dart
import 'package:asa_server_eye/features/profile/presentation/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../../alerts/presentation/screens/alert_settings_screen.dart';
import '../../../favorites/presentation/utils/favorite_actions.dart';
import '../../../sightings/presentation/screens/report_player_sighting_screen.dart';
import '../../../sightings/presentation/screens/server_sightings_screen.dart';
import '../../../subscriptions/presentation/providers/subscription_entitlement_providers.dart';
import '../../../subscriptions/presentation/screens/premium_screen.dart';
import '../providers/is_favorite_provider.dart';
import '../providers/server_by_id_provider.dart';
import '../widgets/server_detail_header_card.dart';
import '../widgets/server_detail_info_card.dart';

class ServerDetailScreen extends ConsumerWidget {
  const ServerDetailScreen({super.key, required this.serverId});

  final String serverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverAsync = ref.watch(serverByIdProvider(serverId));
    final isFavoriteAsync = ref.watch(isFavoriteServerProvider(serverId));
    final entitlementAsync = ref.watch(currentSubscriptionEntitlementProvider);
    final profileAsync = ref.watch(profileProvider);

    final accessLevel =
        profileAsync.valueOrNull?.sightingsAccessLevel ?? 'free';
    final isAdmin = accessLevel == 'admin';
    final isProfilePremium = accessLevel == 'premium';
    final isPremiumEntitled = entitlementAsync.valueOrNull?.isActive ?? false;

    final hasAlertAccess = isAdmin || isProfilePremium || isPremiumEntitled;
    final isAccessStateResolved =
        profileAsync.hasValue && entitlementAsync.hasValue;

    final serverForActions = serverAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.serverDetails),
        actions: [
          if (isAccessStateResolved &&
              hasAlertAccess &&
              serverForActions != null)
            IconButton(
              tooltip: context.l10n.manageAlertRules,
              icon: const Icon(Icons.notifications_active_outlined),
              onPressed: () => _openAlertSettings(
                context: context,
                serverId: serverForActions.id,
                serverName: serverForActions.name,
                mapName: serverForActions.map,
              ),
            ),
        ],
      ),
      body: serverAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(context.l10n.genericError, textAlign: TextAlign.center),
          ),
        ),
        data: (server) {
          if (server == null) {
            return Center(child: Text(context.l10n.serverNotFound));
          }

          return isFavoriteAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  context.l10n.genericError,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            data: (isFavorite) {
              return _buildDetailList(
                context: context,
                ref: ref,
                server: server,
                isFavorite: isFavorite,
                showPremiumAlertUpsell:
                    isAccessStateResolved && !hasAlertAccess,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailList({
    required BuildContext context,
    required WidgetRef ref,
    required dynamic server,
    required bool isFavorite,
    required bool showPremiumAlertUpsell,
  }) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ServerDetailHeaderCard(
          server: server,
          officialLabel: context.l10n.official,
          unofficialLabel: context.l10n.unofficial,
        ),
        const SizedBox(height: 16),
        ServerDetailInfoCard(
          mapLabel: context.l10n.map,
          mapValue: server.map,
          populationLabel: context.l10n.population,
          populationValue: '${server.players}/${server.maxPlayers}',
          typeLabel: context.l10n.type,
          typeValue: server.official
              ? context.l10n.official
              : context.l10n.unofficial,
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () => FavoriteActions.toggleFavorite(
            context: context,
            ref: ref,
            serverId: server.id,
            isFavorite: isFavorite,
          ),
          icon: Icon(
            isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
          ),
          label: Text(
            isFavorite
                ? context.l10n.removeFromFavorites
                : context.l10n.addToFavorites,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ServerSightingsScreen(serverId: server.id),
              ),
            );
          },
          icon: const Icon(Icons.visibility_rounded),
          label: Text(context.l10n.viewPlayerSightings),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ReportPlayerSightingScreen(serverId: server.id),
              ),
            );
          },
          icon: const Icon(Icons.person_add_alt_1_rounded),
          label: Text(context.l10n.reportPlayerSighting),
        ),
        if (showPremiumAlertUpsell) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _openPremiumScreen(context),
            icon: const Icon(Icons.workspace_premium_outlined),
            label: Text(context.l10n.unlockAlertsWithPremium),
          ),
        ],
      ],
    );
  }

  void _openAlertSettings({
    required BuildContext context,
    required String serverId,
    required String serverName,
    required String mapName,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AlertSettingsScreen(
          serverId: serverId,
          serverName: serverName,
          mapName: mapName,
        ),
      ),
    );
  }

  void _openPremiumScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PremiumScreen()));
  }
}
