// features/sightings/presentation/screens/report_player_sighting_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/player_sighting.dart';
import '../controllers/report_player_sighting_controller.dart';

class ReportPlayerSightingScreen extends ConsumerWidget {
  const ReportPlayerSightingScreen({super.key, required this.serverId});

  final String serverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportPlayerSightingControllerProvider(serverId));
    final controller = ref.read(
      reportPlayerSightingControllerProvider(serverId).notifier,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Player melden')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            onChanged: controller.updatePlayerId,
            decoration: InputDecoration(
              labelText: 'Plattform-ID',
              hintText: 'Steam / Xbox / PSN ID',
              errorText: state.playerIdError,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: controller.updatePlayerName,
            decoration: InputDecoration(
              labelText: 'Playername',
              errorText: state.playerNameError,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<GamingPlatform>(
            initialValue: state.platform,
            decoration: const InputDecoration(
              labelText: 'Plattform',
              border: OutlineInputBorder(),
            ),
            items: GamingPlatform.values
                .where((platform) => platform != GamingPlatform.unknown)
                .map(
                  (platform) => DropdownMenuItem<GamingPlatform>(
                    value: platform,
                    child: Text(_platformLabel(platform)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.updatePlatform(value);
              }
            },
          ),
          const SizedBox(height: 16),
          if (state.canChoosePremiumSharing)
            SwitchListTile(
              value: state.shareWithPremiumUsers,
              onChanged: controller.updateShareWithPremiumUsers,
              title: const Text('Für andere Premium-User sichtbar'),
              contentPadding: EdgeInsets.zero,
            ),
          if (state.canChoosePremiumSharing) const SizedBox(height: 16),
          TextField(
            onChanged: controller.updateNote,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Notiz',
              hintText: 'Optional',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          if (state.submitError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                state.submitError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          FilledButton.icon(
            onPressed: state.isSubmitting
                ? null
                : () async {
                    final success = await controller.submit();

                    if (!context.mounted) {
                      return;
                    }

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sichtung gespeichert.')),
                      );
                      Navigator.of(context).pop();
                    }
                  },
            icon: state.isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_rounded),
            label: Text(
              state.isSubmitting ? 'Speichert...' : 'Sichtung speichern',
            ),
          ),
        ],
      ),
    );
  }

  static String _platformLabel(GamingPlatform platform) {
    switch (platform) {
      case GamingPlatform.steam:
        return 'Steam';
      case GamingPlatform.xbox:
        return 'Xbox';
      case GamingPlatform.psn:
        return 'PSN';
      case GamingPlatform.unknown:
        return 'Unknown';
    }
  }
}
