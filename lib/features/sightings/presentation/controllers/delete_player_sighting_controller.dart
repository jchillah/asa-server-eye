// features/sightings/presentation/controllers/delete_player_sighting_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/player_sighting.dart';
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
    this.reasonError,
    this.submitError,
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  final String reason;
  final String? reasonError;
  final String? submitError;
  final bool isSubmitting;
  final bool isSuccess;

  DeletePlayerSightingState copyWith({
    String? reason,
    String? reasonError,
    String? submitError,
    bool? isSubmitting,
    bool? isSuccess,
    bool clearReasonError = false,
    bool clearSubmitError = false,
  }) {
    return DeletePlayerSightingState(
      reason: reason ?? this.reason,
      reasonError: clearReasonError ? null : reasonError ?? this.reasonError,
      submitError: clearSubmitError ? null : submitError ?? this.submitError,
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
    final currentUser = _ref.read(currentUserProvider);

    if (currentUser == null || currentUser.uid != _sighting.createdByUserId) {
      state = state.copyWith(
        submitError: 'Du darfst diese Sichtung nicht löschen.',
      );
      return false;
    }

    final reason = state.reason.trim();

    if (reason.isEmpty) {
      state = state.copyWith(
        reasonError: 'Bitte Grund angeben.',
        clearSubmitError: true,
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      final repository = _ref.read(sightingsRepositoryProvider);

      await repository.softDeleteSighting(
        sightingId: _sighting.id,
        deletedByUserId: currentUser.uid,
        reason: reason,
      );

      _ref.invalidate(rawServerSightingsProvider(_sighting.serverId));
      _ref.invalidate(serverSightingsProvider(_sighting.serverId));
      _ref.invalidate(sightingHistoryProvider(_sighting.id));

      state = state.copyWith(isSubmitting: false, isSuccess: true);

      return true;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        submitError: 'Sichtung konnte nicht ausgeblendet werden.',
      );
      return false;
    }
  }
}
