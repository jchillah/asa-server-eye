// features/sightings/presentation/screens/delete_player_sighting_screen.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
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
      appBar: AppBar(title: Text(context.l10n.deleteSighting)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(context.l10n.sightingDeleteHint),
          const SizedBox(height: 16),
          TextField(
            onChanged: controller.updateReason,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: context.l10n.reason,
              hintText: context.l10n.reasonHint,
              errorText: _mapMessage(context, state.reasonErrorKey),
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          if (state.submitErrorKey != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _mapMessage(context, state.submitErrorKey) ??
                    context.l10n.genericError,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          FilledButton.icon(
            onPressed: state.isSubmitting
                ? null
                : () async {
                    final success = await controller.submit();

                    if (!context.mounted) return;

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.sightingHidden)),
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
            label: Text(
              state.isSubmitting
                  ? context.l10n.saving
                  : context.l10n.hideSighting,
            ),
          ),
        ],
      ),
    );
  }

  String? _mapMessage(BuildContext context, String? key) {
    switch (key) {
      case 'sightingReasonRequired':
        return context.l10n.sightingReasonRequired;
      case 'sightingDeleteNotAllowed':
        return context.l10n.sightingDeleteNotAllowed;
      case 'sightingHideError':
        return context.l10n.sightingHideError;
      default:
        return null;
    }
  }
}
