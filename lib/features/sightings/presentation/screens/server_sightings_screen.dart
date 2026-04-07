// features/sightings/presentation/screens/server_sightings_screen.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:asa_server_eye/features/auth/presentation/providers/current_user.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/sightings_access_level.dart';
import '../controllers/server_sightings_controller.dart';
import '../providers/sightings_access_providers.dart';
import '../widgets/player_sighting_list_item.dart';
import 'delete_player_sighting_screen.dart';
import 'edit_player_sighting_screen.dart';
import 'player_sighting_history_screen.dart';

class ServerSightingsScreen extends ConsumerWidget {
  const ServerSightingsScreen({super.key, required this.serverId});

  final String serverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sightingsAsync = ref.watch(
      serverSightingsControllerProvider(serverId),
    );
    final accessLevelAsync = ref.watch(sightingsAccessLevelProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.playerSightings)),
      body: accessLevelAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              context.l10n.accessLevelLoadError,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (accessLevel) {
          return sightingsAsync.when(
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

                  final isOwner =
                      currentUser != null &&
                      sighting.createdByUserId == currentUser.uid;

                  final canEdit = isOwner && sighting.isVisible;
                  final canDelete =
                      isOwner &&
                      sighting.isVisible &&
                      accessLevel != SightingsAccessLevel.admin;

                  final canSeeHistory =
                      accessLevel == SightingsAccessLevel.admin || isOwner;

                  return PlayerSightingListItem(
                    sighting: sighting,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => EditPlayerSightingScreen(
                                  sighting: sighting,
                                ),
                              ),
                            );
                            break;
                          case 'delete':
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DeletePlayerSightingScreen(
                                  sighting: sighting,
                                ),
                              ),
                            );
                            break;
                          case 'history':
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PlayerSightingHistoryScreen(
                                  sightingId: sighting.id,
                                ),
                              ),
                            );
                            break;
                        }
                      },
                      itemBuilder: (_) => [
                        if (canEdit)
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Text(context.l10n.edit),
                          ),
                        if (canDelete)
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text(context.l10n.delete),
                          ),
                        if (canSeeHistory)
                          PopupMenuItem<String>(
                            value: 'history',
                            child: Text(context.l10n.viewHistory),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  context.l10n.sightingsLoadError,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
