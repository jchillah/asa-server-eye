// features/sightings/presentation/screens/delete_player_sighting_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/player_sighting.dart';
import '../controllers/delete_player_sighting_controller.dart';

class DeletePlayerSightingScreen extends ConsumerWidget {
  const DeletePlayerSightingScreen({super.key, required this.sighting});

  final PlayerSighting sighting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deletePlayerSightingControllerProvider(sighting));
    final controller = ref.read(
      deletePlayerSightingControllerProvider(sighting).notifier,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Sichtung löschen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Die Sichtung wird nicht endgültig gelöscht. '
            'Sie wird nur für normale Nutzer ausgeblendet und bleibt für Admins nachvollziehbar.',
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: controller.updateReason,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Grund',
              hintText: 'Bitte Grund angeben',
              errorText: state.reasonError,
              border: const OutlineInputBorder(),
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
                        const SnackBar(content: Text('Sichtung ausgeblendet.')),
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
                : const Icon(Icons.delete_outline_rounded),
            label: Text(state.isSubmitting ? 'Speichert...' : 'Löschen'),
          ),
        ],
      ),
    );
  }
}
