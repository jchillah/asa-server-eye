// features/sightings/presentation/controllers/edit_player_sighting_controller.dart
import 'package:asa_server_eye/features/auth/presentation/providers/current_user_provider.dart';
import 'package:asa_server_eye/features/sightings/domain/gaming_platform.dart';
import 'package:asa_server_eye/features/sightings/domain/sighting_sharing_scope.dart';
import 'package:asa_server_eye/features/sightings/domain/sightings_access_level.dart';
import 'package:asa_server_eye/features/sightings/domain/sightings_sharing_policy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/player_sighting.dart';
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
    required this.inGameName,
    required this.playerPlatformId,
    required this.tribeName,
    required this.note,
    required this.platform,
    required this.shareWithPremiumUsers,
    required this.canChoosePremiumSharing,
    this.inGameNameErrorKey,
    this.playerPlatformIdErrorKey,
    this.tribeNameErrorKey,
    this.submitErrorKey,
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  final String inGameName;
  final String playerPlatformId;
  final String tribeName;
  final String note;
  final GamingPlatform platform;
  final bool shareWithPremiumUsers;
  final bool canChoosePremiumSharing;
  final String? inGameNameErrorKey;
  final String? playerPlatformIdErrorKey;
  final String? tribeNameErrorKey;
  final String? submitErrorKey;
  final bool isSubmitting;
  final bool isSuccess;

  EditPlayerSightingState copyWith({
    String? inGameName,
    String? playerPlatformId,
    String? tribeName,
    String? note,
    GamingPlatform? platform,
    bool? shareWithPremiumUsers,
    bool? canChoosePremiumSharing,
    String? inGameNameErrorKey,
    String? playerPlatformIdErrorKey,
    String? tribeNameErrorKey,
    String? submitErrorKey,
    bool? isSubmitting,
    bool? isSuccess,
    bool clearInGameNameError = false,
    bool clearPlayerPlatformIdError = false,
    bool clearTribeNameError = false,
    bool clearSubmitError = false,
  }) {
    return EditPlayerSightingState(
      inGameName: inGameName ?? this.inGameName,
      playerPlatformId: playerPlatformId ?? this.playerPlatformId,
      tribeName: tribeName ?? this.tribeName,
      note: note ?? this.note,
      platform: platform ?? this.platform,
      shareWithPremiumUsers:
          shareWithPremiumUsers ?? this.shareWithPremiumUsers,
      canChoosePremiumSharing:
          canChoosePremiumSharing ?? this.canChoosePremiumSharing,
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
          inGameName: _sighting.inGameName,
          playerPlatformId: _sighting.playerPlatformId,
          tribeName: _sighting.tribeName,
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
    final currentUserId = _ref.read(currentUserProvider)?.uid;
    final isOwner = currentUserId == _sighting.createdByUserId;

    state = state.copyWith(
      canChoosePremiumSharing:
          isOwner && accessLevel == SightingsAccessLevel.premium,
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
    final accessLevel = await _ref.read(sightingsAccessLevelProvider.future);

    final isOwner =
        currentUser != null && currentUser.uid == _sighting.createdByUserId;
    final isAdminModerator = accessLevel == SightingsAccessLevel.admin;

    if (currentUser == null || (!isOwner && !isAdminModerator)) {
      state = state.copyWith(
        submitErrorKey: 'sightingEditNotAllowed',
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
      final sharingScope = state.canChoosePremiumSharing
          ? SightingSharingPolicy.resolve(
              accessLevel: accessLevel,
              shareWithPremiumUsers: state.shareWithPremiumUsers,
            )
          : _sighting.sharingScope;

      await _ref
          .read(sightingsRepositoryProvider)
          .updateSighting(
            sightingId: _sighting.id,
            editedByUserId: currentUser.uid,
            inGameName: inGameName,
            playerPlatformId: playerPlatformId,
            tribeName: tribeName,
            platform: state.platform,
            sharingScope: sharingScope,
            note: state.note.trim().isEmpty ? null : state.note.trim(),
          );

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
        submitErrorKey: 'sightingUpdateError',
        isSuccess: false,
      );
      return false;
    }
  }
}
