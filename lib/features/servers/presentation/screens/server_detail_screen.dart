// features/servers/presentation/screens/server_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../../favorites/presentation/utils/favorite_actions.dart';
import '../providers/server_view_providers.dart';
import '../widgets/server_detail_header_card.dart';
import '../widgets/server_detail_info_card.dart';

class ServerDetailScreen extends ConsumerWidget {
  const ServerDetailScreen({super.key, required this.serverId});

  final String serverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverAsync = ref.watch(serverByIdProvider(serverId));
    final isFavoriteAsync = ref.watch(isFavoriteServerProvider(serverId));

    if (serverAsync.hasError || isFavoriteAsync.hasError) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.serverDetails)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(context.l10n.genericError, textAlign: TextAlign.center),
          ),
        ),
      );
    }

    if (serverAsync.isLoading || isFavoriteAsync.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.serverDetails)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final server = serverAsync.value;
    final isFavorite = isFavoriteAsync.value ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.serverDetails)),
      body: server == null
          ? Center(child: Text(context.l10n.serverNotFound))
          : ListView(
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
              ],
            ),
    );
  }
}
