// features/sightings/presentation/controllers/report_player_sighting_controller.dart
import 'package:asa_server_eye/features/auth/presentation/providers/current_user_provider.dart';
import 'package:asa_server_eye/features/sightings/domain/gaming_platform.dart';
import 'package:asa_server_eye/features/sightings/domain/sighting_creator_level_policy.dart';
import 'package:asa_server_eye/features/sightings/domain/sightings_access_level.dart';
import 'package:asa_server_eye/features/sightings/domain/sightings_sharing_policy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    this.inGameName = '',
    this.playerPlatformId = '',
    this.tribeName = '',
    this.note = '',
    this.platform = GamingPlatform.steam,
    this.shareWithPremiumUsers = true,
    this.canChoosePremiumSharing = false,
    this.isSubmitting = false,
    this.inGameNameErrorKey,
    this.playerPlatformIdErrorKey,
    this.tribeNameErrorKey,
    this.submitErrorKey,
    this.isSuccess = false,
  });

  final String inGameName;
  final String playerPlatformId;
  final String tribeName;
  final String note;
  final GamingPlatform platform;
  final bool shareWithPremiumUsers;
  final bool canChoosePremiumSharing;
  final bool isSubmitting;
  final String? inGameNameErrorKey;
  final String? playerPlatformIdErrorKey;
  final String? tribeNameErrorKey;
  final String? submitErrorKey;
  final bool isSuccess;

  ReportPlayerSightingState copyWith({
    String? inGameName,
    String? playerPlatformId,
    String? tribeName,
    String? note,
    GamingPlatform? platform,
    bool? shareWithPremiumUsers,
    bool? canChoosePremiumSharing,
    bool? isSubmitting,
    String? inGameNameErrorKey,
    String? playerPlatformIdErrorKey,
    String? tribeNameErrorKey,
    String? submitErrorKey,
    bool? isSuccess,
    bool clearInGameNameError = false,
    bool clearPlayerPlatformIdError = false,
    bool clearTribeNameError = false,
    bool clearSubmitError = false,
  }) {
    return ReportPlayerSightingState(
      inGameName: inGameName ?? this.inGameName,
      playerPlatformId: playerPlatformId ?? this.playerPlatformId,
      tribeName: tribeName ?? this.tribeName,
      note: note ?? this.note,
      platform: platform ?? this.platform,
      shareWithPremiumUsers:
          shareWithPremiumUsers ?? this.shareWithPremiumUsers,
      canChoosePremiumSharing:
          canChoosePremiumSharing ?? this.canChoosePremiumSharing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      inGameNameErrorKey: clearInGameNameError
          ? null
          : inGameNameErrorKey ?? this.inGameNameErrorKey,
      playerPlatformIdErrorKey: clearPlayerPlatformIdError
          ? null
          : playerPlatformIdErrorKey ?? this.playerPlatformIdErrorKey,
      tribeNameErrorKey: clearTribeNameError
          ? null
          : tribeNameErrorKey ?? this.tribeNameErrorKey,
      submitErrorKey: clearSubmitError
          ? null
          : submitErrorKey ?? this.submitErrorKey,
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

  void updateInGameName(String value) {
    state = state.copyWith(
      inGameName: value,
      clearInGameNameError: true,
      clearSubmitError: true,
      isSuccess: false,
    );
  }

  void updatePlayerPlatformId(String value) {
    state = state.copyWith(
      playerPlatformId: value,
      clearPlayerPlatformIdError: true,
      clearSubmitError: true,
      isSuccess: false,
    );
  }

  void updateTribeName(String value) {
    state = state.copyWith(
      tribeName: value,
      clearTribeNameError: true,
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
    final inGameName = state.inGameName.trim();
    final playerPlatformId = state.playerPlatformId.trim();
    final tribeName = state.tribeName.trim();

    String? inGameNameErrorKey;
    String? playerPlatformIdErrorKey;
    String? tribeNameErrorKey;

    if (inGameName.isEmpty) {
      inGameNameErrorKey = 'sightingInGameNameRequired';
    }

    if (playerPlatformId.isEmpty) {
      playerPlatformIdErrorKey = 'sightingPlatformIdRequired';
    }

    if (tribeName.isEmpty) {
      tribeNameErrorKey = 'sightingTribeNameRequired';
    }

    if (inGameNameErrorKey != null ||
        playerPlatformIdErrorKey != null ||
        tribeNameErrorKey != null) {
      state = state.copyWith(
        inGameNameErrorKey: inGameNameErrorKey,
        playerPlatformIdErrorKey: playerPlatformIdErrorKey,
        tribeNameErrorKey: tribeNameErrorKey,
        clearSubmitError: true,
        isSuccess: false,
      );
      return false;
    }

    final currentUser = _ref.read(currentUserProvider);

    if (currentUser == null) {
      state = state.copyWith(
        submitErrorKey: 'sightingRequiresLogin',
        clearInGameNameError: true,
        clearPlayerPlatformIdError: true,
        clearTribeNameError: true,
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
      final userProfile = await _ref.read(sightingsUserProfileProvider.future);

      if (userProfile == null) {
        state = state.copyWith(
          isSubmitting: false,
          submitErrorKey: 'sightingUserProfileLoadError',
          isSuccess: false,
        );
        return false;
      }

      final creatorLevel = SightingCreatorLevelPolicy.resolve(
        accessLevel: userProfile.accessLevel,
      );

      final sharingScope = SightingSharingPolicy.resolve(
        accessLevel: userProfile.accessLevel,
        shareWithPremiumUsers: state.shareWithPremiumUsers,
      );

      final repository = _ref.read(sightingsRepositoryProvider);

      await repository.createSighting(
        serverId: _serverId,
        inGameName: inGameName,
        playerPlatformId: playerPlatformId,
        tribeName: tribeName,
        platform: state.platform,
        createdByUserId: currentUser.uid,
        createdByUsername: userProfile.username,
        createdByEmail: userProfile.email,
        creatorLevel: creatorLevel,
        sharingScope: sharingScope,
        note: state.note.trim().isEmpty ? null : state.note.trim(),
      );

      _ref.invalidate(serverSightingsProvider(_serverId));
      _ref.invalidate(sightingsAccessLevelProvider);
      _ref.invalidate(sightingsUserProfileProvider);

      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        clearSubmitError: true,
      );

      return true;
    } catch (error, stackTrace) {
      // ignore: avoid_print
      print('Sighting save failed: $error');
      // ignore: avoid_print
      print(stackTrace);

      state = state.copyWith(
        isSubmitting: false,
        submitErrorKey: 'sightingSaveError',
        isSuccess: false,
      );
      return false;
    }
  }
}
