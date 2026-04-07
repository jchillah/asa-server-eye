// features/sightings/presentation/controllers/delete_player_sighting_controller.dart
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/sightings_repository.dart';
import '../../domain/player_sighting.dart';
import '../providers/sightings_providers.dart';

final deletePlayerSightingControllerProvider = StateNotifierProvider.autoDispose
    .family<
      DeletePlayerSightingController,
      DeletePlayerSightingState,
      PlayerSighting
    >((ref, sighting) {
      final repository = ref.watch(sightingsRepositoryProvider);
      final currentUserId = ref.watch(currentUserIdProvider);

      return DeletePlayerSightingController(
        repository: repository,
        sighting: sighting,
        currentUserId: currentUserId,
        onCompleted: () {
          ref.invalidate(rawServerSightingsProvider(sighting.serverId));
          ref.invalidate(serverSightingsProvider(sighting.serverId));
          ref.invalidate(sightingHistoryProvider(sighting.id));
        },
      );
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
  DeletePlayerSightingController({
    required SightingsRepository repository,
    required PlayerSighting sighting,
    required String? currentUserId,
    required VoidCallback onCompleted,
  }) : _repository = repository,
       _sighting = sighting,
       _currentUserId = currentUserId,
       _onCompleted = onCompleted,
       super(const DeletePlayerSightingState());

  final SightingsRepository _repository;
  final PlayerSighting _sighting;
  final String? _currentUserId;
  final VoidCallback _onCompleted;

  void updateReason(String value) {
    state = state.copyWith(
      reason: value,
      clearReasonError: true,
      clearSubmitError: true,
      isSuccess: false,
    );
  }

  Future<bool> submit() async {
    if (_currentUserId == null || _currentUserId != _sighting.createdByUserId) {
      state = state.copyWith(submitErrorKey: 'sightingDeleteNotAllowed');
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
      await _repository.softDeleteSighting(
        sightingId: _sighting.id,
        deletedByUserId: _currentUserId,
        reason: reason,
      );

      _onCompleted();

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
