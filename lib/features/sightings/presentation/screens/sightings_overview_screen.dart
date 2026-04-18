// features/sightings/presentation/screens/sightings_overview_screen.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../servers/presentation/providers/servers_provider.dart';
import '../providers/sightings_providers.dart';
import '../widgets/player_sighting_list_item.dart';
import 'server_sightings_screen.dart';

class SightingsOverviewScreen extends ConsumerWidget {
  const SightingsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sightingsAsync = ref.watch(sightingsOverviewProvider);
    final serversAsync = ref.watch(serversProvider);
    final theme = Theme.of(context);

    final serverNameById = {
      for (final server in serversAsync.valueOrNull ?? const [])
        server.id: server.name,
    };

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.playerSightings)),
      body: sightingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              context.l10n.sightingsLoadError,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (sightings) {
          if (sightings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  context.l10n.noVisibleSightings,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sightings.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final sighting = sightings[index];
              final serverLabel =
                  serverNameById[sighting.serverId] ?? sighting.serverId;

              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ServerSightingsScreen(serverId: sighting.serverId),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        serverLabel,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    PlayerSightingListItem(sighting: sighting),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
