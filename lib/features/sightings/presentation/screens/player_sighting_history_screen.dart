// features/sightings/presentation/screens/player_sighting_history_screen.dart
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
      appBar: AppBar(title: const Text('Änderungsverlauf')),
      body: historyAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Noch kein Verlauf vorhanden.',
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Verlauf konnte nicht geladen werden.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
