// features/sightings/presentation/controllers/delete_player_sighting_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/player_sighting.dart';
import '../../domain/sightings_access_level.dart';
import '../providers/sightings_access_providers.dart';
import '../providers/sightings_providers.dart';

final deletePlayerSightingControllerProvider = StateNotifierProvider.autoDispose
    .family<
      DeletePlayerSightingController,
      DeletePlayerSightingState,
      PlayerSighting
    >((ref, sighting) {
      return DeletePlayerSightingController(ref, sighting);
    });

class DeletePlayerSightingState {
  const DeletePlayerSightingState({
    this.reason = '',
    this.reasonErrorKey,
    this.submitErrorKey,
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  final String reason;
  final String? reasonErrorKey;
  final String? submitErrorKey;
  final bool isSubmitting;
  final bool isSuccess;

  DeletePlayerSightingState copyWith({
    String? reason,
    String? reasonErrorKey,
    String? submitErrorKey,
    bool? isSubmitting,
    bool? isSuccess,
    bool clearReasonError = false,
    bool clearSubmitError = false,
  }) {
    return DeletePlayerSightingState(
      reason: reason ?? this.reason,
      reasonErrorKey: clearReasonError
          ? null
          : reasonErrorKey ?? this.reasonErrorKey,
      submitErrorKey: clearSubmitError
          ? null
          : submitErrorKey ?? this.submitErrorKey,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class DeletePlayerSightingController
    extends StateNotifier<DeletePlayerSightingState> {
  DeletePlayerSightingController(this._ref, this._sighting)
    : super(const DeletePlayerSightingState());

  final Ref _ref;
  final PlayerSighting _sighting;

  void updateReason(String value) {
    state = state.copyWith(
      reason: value,
      clearReasonError: true,
      clearSubmitError: true,
      isSuccess: false,
    );
  }

  Future<bool> submit() async {
    final currentUserId = _ref.read(currentUserIdProvider);
    final accessLevel = await _ref.read(sightingsAccessLevelProvider.future);

    final canDelete =
        currentUserId != null &&
        (currentUserId == _sighting.createdByUserId ||
            accessLevel == SightingsAccessLevel.admin);

    if (!canDelete) {
      state = state.copyWith(
        submitErrorKey: 'sightingDeleteNotAllowed',
        isSuccess: false,
      );
      return false;
    }

    final reason = state.reason.trim();

    if (reason.isEmpty) {
      state = state.copyWith(
        reasonErrorKey: 'sightingReasonRequired',
        clearSubmitError: true,
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      await _ref
          .read(sightingsRepositoryProvider)
          .softDeleteSighting(
            sightingId: _sighting.id,
            deletedByUserId: currentUserId,
            reason: reason,
          );

      _ref.invalidate(serverSightingsProvider(_sighting.serverId));
      _ref.invalidate(sightingHistoryProvider(_sighting.id));

      state = state.copyWith(isSubmitting: false, isSuccess: true);
      return true;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        submitErrorKey: 'sightingHideError',
      );
      return false;
    }
  }
}
