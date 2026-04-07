// features/sightings/presentation/screens/player_sighting_history_screen.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/sightings_providers.dart';
import '../widgets/sighting_change_log_list_item.dart';

class PlayerSightingHistoryScreen extends ConsumerWidget {
  const PlayerSightingHistoryScreen({super.key, required this.sightingId});

  final String sightingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(sightingHistoryProvider(sightingId));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sightingHistory)),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              context.l10n.sightingHistoryLoadError,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (logs) {
          if (logs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  context.l10n.noSightingHistory,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: logs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return SightingChangeLogListItem(log: logs[index]);
            },
          );
        },
      ),
    );
  }
}
