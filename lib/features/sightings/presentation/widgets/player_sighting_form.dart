// features/sightings/presentation/widgets/player_sighting_form.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:asa_server_eye/features/sightings/domain/gaming_platform.dart';
import 'package:flutter/material.dart';

import '../extensions/gaming_platform_l10n_extension.dart';

class PlayerSightingForm extends StatelessWidget {
  const PlayerSightingForm({
    super.key,
    required this.playerPlatformIdController,
    required this.inGameNameController,
    required this.tribeNameController,
    required this.noteController,
    required this.platform,
    required this.canChoosePremiumSharing,
    required this.shareWithPremiumUsers,
    required this.isSubmitting,
    required this.playerPlatformIdErrorText,
    required this.inGameNameErrorText,
    required this.tribeNameErrorText,
    required this.submitErrorText,
    required this.submitButtonLabel,
    required this.onPlayerPlatformIdChanged,
    required this.onInGameNameChanged,
    required this.onTribeNameChanged,
    required this.onNoteChanged,
    required this.onPlatformChanged,
    required this.onShareWithPremiumUsersChanged,
    required this.onSubmit,
  });

  final TextEditingController playerPlatformIdController;
  final TextEditingController inGameNameController;
  final TextEditingController tribeNameController;
  final TextEditingController noteController;
  final GamingPlatform platform;
  final bool canChoosePremiumSharing;
  final bool shareWithPremiumUsers;
  final bool isSubmitting;
  final String? playerPlatformIdErrorText;
  final String? inGameNameErrorText;
  final String? tribeNameErrorText;
  final String? submitErrorText;
  final String submitButtonLabel;
  final ValueChanged<String> onPlayerPlatformIdChanged;
  final ValueChanged<String> onInGameNameChanged;
  final ValueChanged<String> onTribeNameChanged;
  final ValueChanged<String> onNoteChanged;
  final ValueChanged<GamingPlatform> onPlatformChanged;
  final ValueChanged<bool> onShareWithPremiumUsersChanged;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: playerPlatformIdController,
          onChanged: onPlayerPlatformIdChanged,
          decoration: InputDecoration(
            labelText: context.l10n.platformId,
            hintText: context.l10n.platformIdHint,
            errorText: playerPlatformIdErrorText,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: inGameNameController,
          onChanged: onInGameNameChanged,
          decoration: InputDecoration(
            labelText: context.l10n.inGameName,
            errorText: inGameNameErrorText,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: tribeNameController,
          onChanged: onTribeNameChanged,
          decoration: InputDecoration(
            labelText: context.l10n.tribeName,
            hintText: context.l10n.tribeNameHint,
            errorText: tribeNameErrorText,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<GamingPlatform>(
          initialValue: platform,
          decoration: InputDecoration(
            labelText: context.l10n.platform,
            border: const OutlineInputBorder(),
          ),
          items: GamingPlatform.values
              .where((item) => item != GamingPlatform.unknown)
              .map(
                (item) => DropdownMenuItem<GamingPlatform>(
                  value: item,
                  child: Text(item.label(context)),
                ),
              )
              .toList(),
          onChanged: isSubmitting
              ? null
              : (value) {
                  if (value != null) {
                    onPlatformChanged(value);
                  }
                },
        ),
        const SizedBox(height: 16),
        if (canChoosePremiumSharing)
          SwitchListTile(
            value: shareWithPremiumUsers,
            onChanged: isSubmitting ? null : onShareWithPremiumUsersChanged,
            title: Text(context.l10n.visibleToPremiumUsers),
            contentPadding: EdgeInsets.zero,
          ),
        if (canChoosePremiumSharing) const SizedBox(height: 16),
        TextField(
          controller: noteController,
          onChanged: onNoteChanged,
          minLines: 3,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: context.l10n.note,
            hintText: context.l10n.optional,
            border: const OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 16),
        if (submitErrorText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              submitErrorText!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        FilledButton.icon(
          onPressed: isSubmitting ? null : onSubmit,
          icon: isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_rounded),
          label: Text(isSubmitting ? context.l10n.saving : submitButtonLabel),
        ),
      ],
    );
  }
}
