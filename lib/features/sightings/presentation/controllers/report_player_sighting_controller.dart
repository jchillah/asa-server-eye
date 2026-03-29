// features/sightings/presentation/controllers/report_player_sighting_controller.dart
import 'package:asa_server_eye/features/auth/presentation/providers/current_user.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/player_sighting.dart';
import '../../domain/sightings_access_level.dart';
import '../../domain/sightings_visibility_mapper.dart';
import '../providers/sightings_access_providers.dart';
import '../providers/sightings_providers.dart';

final reportPlayerSightingControllerProvider = StateNotifierProvider.autoDispose
    .family<ReportPlayerSightingController, ReportPlayerSightingState, String>((
      ref,
      serverId,
    ) {
      return ReportPlayerSightingController(ref, serverId);
    });

class ReportPlayerSightingState {
  const ReportPlayerSightingState({
    this.playerName = '',
    this.playerId = '',
    this.note = '',
    this.platform = GamingPlatform.steam,
    this.shareWithPremiumUsers = true,
    this.canChoosePremiumSharing = false,
    this.isSubmitting = false,
    this.playerNameError,
    this.playerIdError,
    this.submitError,
    this.isSuccess = false,
  });

  final String playerName;
  final String playerId;
  final String note;
  final GamingPlatform platform;
  final bool shareWithPremiumUsers;
  final bool canChoosePremiumSharing;
  final bool isSubmitting;
  final String? playerNameError;
  final String? playerIdError;
  final String? submitError;
  final bool isSuccess;

  ReportPlayerSightingState copyWith({
    String? playerName,
    String? playerId,
    String? note,
    GamingPlatform? platform,
    bool? shareWithPremiumUsers,
    bool? canChoosePremiumSharing,
    bool? isSubmitting,
    String? playerNameError,
    String? playerIdError,
    String? submitError,
    bool? isSuccess,
    bool clearPlayerNameError = false,
    bool clearPlayerIdError = false,
    bool clearSubmitError = false,
  }) {
    return ReportPlayerSightingState(
      playerName: playerName ?? this.playerName,
      playerId: playerId ?? this.playerId,
      note: note ?? this.note,
      platform: platform ?? this.platform,
      shareWithPremiumUsers:
          shareWithPremiumUsers ?? this.shareWithPremiumUsers,
      canChoosePremiumSharing:
          canChoosePremiumSharing ?? this.canChoosePremiumSharing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      playerNameError: clearPlayerNameError
          ? null
          : playerNameError ?? this.playerNameError,
      playerIdError: clearPlayerIdError
          ? null
          : playerIdError ?? this.playerIdError,
      submitError: clearSubmitError ? null : submitError ?? this.submitError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class ReportPlayerSightingController
    extends StateNotifier<ReportPlayerSightingState> {
  ReportPlayerSightingController(this._ref, this._serverId)
    : super(const ReportPlayerSightingState()) {
    _loadAccessFlags();
  }

  final Ref _ref;
  final String _serverId;

  Future<void> _loadAccessFlags() async {
    final accessLevel = await _ref.read(sightingsAccessLevelProvider.future);

    state = state.copyWith(
      canChoosePremiumSharing: accessLevel == SightingsAccessLevel.premium,
      shareWithPremiumUsers: accessLevel == SightingsAccessLevel.free,
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

    if (currentUser == null) {
      state = state.copyWith(
        submitError: 'Du musst eingeloggt sein, um eine Sichtung zu melden.',
        clearPlayerNameError: true,
        clearPlayerIdError: true,
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

      final visibilityLevel =
          SightingsVisibilityMapper.creationVisibilityForAccessLevel(
            accessLevel,
          );

      final sharingScope =
          SightingsVisibilityMapper.creationSharingScopeForAccessLevel(
            accessLevel: accessLevel,
            shareWithPremiumUsers: state.shareWithPremiumUsers,
          );

      final repository = _ref.read(sightingsRepositoryProvider);

      await repository.createSighting(
        serverId: _serverId,
        playerName: playerName,
        playerId: playerId,
        platform: state.platform,
        createdByUserId: currentUser.uid,
        visibilityLevel: visibilityLevel,
        sharingScope: sharingScope,
        note: state.note.trim().isEmpty ? null : state.note.trim(),
      );

      _ref.invalidate(rawServerSightingsProvider(_serverId));
      _ref.invalidate(serverSightingsProvider(_serverId));
      _ref.invalidate(sightingsAccessLevelProvider);

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
