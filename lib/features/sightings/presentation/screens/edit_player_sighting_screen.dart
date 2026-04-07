// features/sightings/presentation/screens/edit_player_sighting_screen.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/player_sighting.dart';
import '../controllers/edit_player_sighting_controller.dart';
import '../utils/sightings_message_mapper.dart';
import '../widgets/player_sighting_form.dart';

class EditPlayerSightingScreen extends ConsumerStatefulWidget {
  const EditPlayerSightingScreen({super.key, required this.sighting});

  final PlayerSighting sighting;

  @override
  ConsumerState<EditPlayerSightingScreen> createState() =>
      _EditPlayerSightingScreenState();
}

class _EditPlayerSightingScreenState
    extends ConsumerState<EditPlayerSightingScreen> {
  late final TextEditingController _playerPlatformIdController;
  late final TextEditingController _inGameNameController;
  late final TextEditingController _tribeNameController;
  late final TextEditingController _noteController;

  bool _isHydrated = false;

  @override
  void initState() {
    super.initState();
    _playerPlatformIdController = TextEditingController();
    _inGameNameController = TextEditingController();
    _tribeNameController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _playerPlatformIdController.dispose();
    _inGameNameController.dispose();
    _tribeNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _hydrateIfNeeded(EditPlayerSightingState state) {
    if (_isHydrated) return;

    _playerPlatformIdController.text = state.playerPlatformId;
    _inGameNameController.text = state.inGameName;
    _tribeNameController.text = state.tribeName;
    _noteController.text = state.note;
    _isHydrated = true;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      editPlayerSightingControllerProvider(widget.sighting),
    );
    final controller = ref.read(
      editPlayerSightingControllerProvider(widget.sighting).notifier,
    );

    _hydrateIfNeeded(state);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.editSighting)),
      body: PlayerSightingForm(
        playerPlatformIdController: _playerPlatformIdController,
        inGameNameController: _inGameNameController,
        tribeNameController: _tribeNameController,
        noteController: _noteController,
        platform: state.platform,
        canChoosePremiumSharing: state.canChoosePremiumSharing,
        shareWithPremiumUsers: state.shareWithPremiumUsers,
        isSubmitting: state.isSubmitting,
        playerPlatformIdErrorText: SightingsMessageMapper.map(
          context,
          state.playerPlatformIdErrorKey,
        ),
        inGameNameErrorText: SightingsMessageMapper.map(
          context,
          state.inGameNameErrorKey,
        ),
        tribeNameErrorText: SightingsMessageMapper.map(
          context,
          state.tribeNameErrorKey,
        ),
        submitErrorText: SightingsMessageMapper.map(
          context,
          state.submitErrorKey,
        ),
        submitButtonLabel: context.l10n.updateSighting,
        onPlayerPlatformIdChanged: controller.updatePlayerPlatformId,
        onInGameNameChanged: controller.updateInGameName,
        onTribeNameChanged: controller.updateTribeName,
        onNoteChanged: controller.updateNote,
        onPlatformChanged: controller.updatePlatform,
        onShareWithPremiumUsersChanged: controller.updateShareWithPremiumUsers,
        onSubmit: () async {
          final success = await controller.submit();

          if (!context.mounted) return;

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.sightingUpdated)),
            );
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
