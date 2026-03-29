// features/sightings/presentation/controllers/edit_player_sighting_controller.dart
import 'package:asa_server_eye/features/auth/presentation/providers/current_user.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/player_sighting.dart';
import '../../domain/sightings_access_level.dart';
import '../../domain/sightings_visibility_mapper.dart';
import '../providers/sightings_access_providers.dart';
import '../providers/sightings_providers.dart';

final editPlayerSightingControllerProvider = StateNotifierProvider.autoDispose
    .family<
      EditPlayerSightingController,
      EditPlayerSightingState,
      PlayerSighting
    >((ref, sighting) {
      return EditPlayerSightingController(ref, sighting);
    });

class EditPlayerSightingState {
  const EditPlayerSightingState({
    required this.playerName,
    required this.playerId,
    required this.note,
    required this.platform,
    required this.shareWithPremiumUsers,
    required this.canChoosePremiumSharing,
    this.playerNameError,
    this.playerIdError,
    this.submitError,
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  final String playerName;
  final String playerId;
  final String note;
  final GamingPlatform platform;
  final bool shareWithPremiumUsers;
  final bool canChoosePremiumSharing;
  final String? playerNameError;
  final String? playerIdError;
  final String? submitError;
  final bool isSubmitting;
  final bool isSuccess;

  EditPlayerSightingState copyWith({
    String? playerName,
    String? playerId,
    String? note,
    GamingPlatform? platform,
    bool? shareWithPremiumUsers,
    bool? canChoosePremiumSharing,
    String? playerNameError,
    String? playerIdError,
    String? submitError,
    bool? isSubmitting,
    bool? isSuccess,
    bool clearPlayerNameError = false,
    bool clearPlayerIdError = false,
    bool clearSubmitError = false,
  }) {
    return EditPlayerSightingState(
      playerName: playerName ?? this.playerName,
      playerId: playerId ?? this.playerId,
      note: note ?? this.note,
      platform: platform ?? this.platform,
      shareWithPremiumUsers:
          shareWithPremiumUsers ?? this.shareWithPremiumUsers,
      canChoosePremiumSharing:
          canChoosePremiumSharing ?? this.canChoosePremiumSharing,
      playerNameError: clearPlayerNameError
          ? null
          : playerNameError ?? this.playerNameError,
      playerIdError: clearPlayerIdError
          ? null
          : playerIdError ?? this.playerIdError,
      submitError: clearSubmitError ? null : submitError ?? this.submitError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class EditPlayerSightingController
    extends StateNotifier<EditPlayerSightingState> {
  EditPlayerSightingController(this._ref, this._sighting)
    : super(
        EditPlayerSightingState(
          playerName: _sighting.playerName,
          playerId: _sighting.playerId,
          note: _sighting.note ?? '',
          platform: _sighting.platform,
          shareWithPremiumUsers:
              _sighting.sharingScope == SightingSharingScope.premiumShared,
          canChoosePremiumSharing: false,
        ),
      ) {
    _loadAccessFlags();
  }

  final Ref _ref;
  final PlayerSighting _sighting;

  Future<void> _loadAccessFlags() async {
    final accessLevel = await _ref.read(sightingsAccessLevelProvider.future);

    state = state.copyWith(
      canChoosePremiumSharing: accessLevel == SightingsAccessLevel.premium,
    );
  }

  void updatePlayerName(String value) {
    state = state.copyWith(
      playerName: value,
      clearPlayerNameError: true,
      clearSubmitError: true,
      isSuccess: false,
    );
  }

  void updatePlayerId(String value) {
    state = state.copyWith(
      playerId: value,
      clearPlayerIdError: true,
      clearSubmitError: true,
      isSuccess: false,
    );
  }

  void updateNote(String value) {
    state = state.copyWith(
      note: value,
      clearSubmitError: true,
      isSuccess: false,
    );
  }

  void updatePlatform(GamingPlatform platform) {
    state = state.copyWith(
      platform: platform,
      clearSubmitError: true,
      isSuccess: false,
    );
  }

  void updateShareWithPremiumUsers(bool value) {
    state = state.copyWith(
      shareWithPremiumUsers: value,
      clearSubmitError: true,
      isSuccess: false,
    );
  }

  Future<bool> submit() async {
    final playerName = state.playerName.trim();
    final playerId = state.playerId.trim();

    String? playerNameError;
    String? playerIdError;

    if (playerName.isEmpty) {
      playerNameError = 'Bitte Spielernamen eingeben.';
    }

    if (playerId.isEmpty) {
      playerIdError = 'Bitte Plattform-ID eingeben.';
    }

    if (playerNameError != null || playerIdError != null) {
      state = state.copyWith(
        playerNameError: playerNameError,
        playerIdError: playerIdError,
        clearSubmitError: true,
        isSuccess: false,
      );
      return false;
    }

    final currentUser = _ref.read(currentUserProvider);

    if (currentUser == null || currentUser.uid != _sighting.createdByUserId) {
      state = state.copyWith(
        submitError: 'Du darfst diese Sichtung nicht bearbeiten.',
        isSuccess: false,
      );
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      clearSubmitError: true,
      isSuccess: false,
    );

    try {
      final accessLevel = await _ref.read(sightingsAccessLevelProvider.future);
      final sharingScope =
          SightingsVisibilityMapper.creationSharingScopeForAccessLevel(
            accessLevel: accessLevel,
            shareWithPremiumUsers: state.shareWithPremiumUsers,
          );

      final repository = _ref.read(sightingsRepositoryProvider);

      await repository.updateSighting(
        sightingId: _sighting.id,
        editedByUserId: currentUser.uid,
        playerName: playerName,
        playerId: playerId,
        platform: state.platform,
        sharingScope: sharingScope,
        note: state.note.trim().isEmpty ? null : state.note.trim(),
      );

      _ref.invalidate(rawServerSightingsProvider(_sighting.serverId));
      _ref.invalidate(serverSightingsProvider(_sighting.serverId));
      _ref.invalidate(sightingHistoryProvider(_sighting.id));

      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        clearSubmitError: true,
      );

      return true;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        submitError: 'Sichtung konnte nicht gespeichert werden.',
        isSuccess: false,
      );
      return false;
    }
  }
}
