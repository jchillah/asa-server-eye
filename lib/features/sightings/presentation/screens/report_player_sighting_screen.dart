// features/sightings/presentation/screens/report_player_sighting_screen.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/report_player_sighting_controller.dart';
import '../utils/sightings_message_mapper.dart';
import '../widgets/player_sighting_form.dart';

class ReportPlayerSightingScreen extends ConsumerStatefulWidget {
  const ReportPlayerSightingScreen({super.key, required this.serverId});

  final String serverId;

  @override
  ConsumerState<ReportPlayerSightingScreen> createState() =>
      _ReportPlayerSightingScreenState();
}

class _ReportPlayerSightingScreenState
    extends ConsumerState<ReportPlayerSightingScreen> {
  late final TextEditingController _playerPlatformIdController;
  late final TextEditingController _inGameNameController;
  late final TextEditingController _tribeNameController;
  late final TextEditingController _noteController;

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      reportPlayerSightingControllerProvider(widget.serverId),
    );
    final controller = ref.read(
      reportPlayerSightingControllerProvider(widget.serverId).notifier,
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.playerSightingReport)),
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
        submitButtonLabel: context.l10n.saveSighting,
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
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(context.l10n.sightingSaved)));
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
