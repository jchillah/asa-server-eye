// features/sightings/presentation/controllers/manage_player_sighting_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/player_sighting.dart';
import '../../domain/sightings_visibility_mapper.dart';
import '../providers/sightings_access_providers.dart';
import '../providers/sightings_providers.dart';

final managePlayerSightingControllerProvider =
    Provider<ManagePlayerSightingController>((ref) {
      return ManagePlayerSightingController(ref);
    });

class ManagePlayerSightingController {
  const ManagePlayerSightingController(this._ref);

  final Ref _ref;

  Future<void> softDelete({
    required String sightingId,
    required String serverId,
    required String reason,
  }) async {
    final currentUser = _ref.read(currentUserProvider);

    if (currentUser == null) {
      throw StateError('User not logged in');
    }

    final repository = _ref.read(sightingsRepositoryProvider);

    await repository.softDeleteSighting(
      sightingId: sightingId,
      deletedByUserId: currentUser.uid,
      reason: reason,
    );

    _ref.invalidate(rawServerSightingsProvider(serverId));
    _ref.invalidate(serverSightingsProvider(serverId));
    _ref.invalidate(sightingHistoryProvider(sightingId));
  }

  Future<void> update({
    required String sightingId,
    required String serverId,
    required String playerName,
    required String playerId,
    required GamingPlatform platform,
    required bool shareWithPremiumUsers,
    String? note,
  }) async {
    final currentUser = _ref.read(currentUserProvider);

    if (currentUser == null) {
      throw StateError('User not logged in');
    }

    final accessLevel = await _ref.read(sightingsAccessLevelProvider.future);

    final sharingScope =
        SightingsVisibilityMapper.creationSharingScopeForAccessLevel(
          accessLevel: accessLevel,
          shareWithPremiumUsers: shareWithPremiumUsers,
        );

    final repository = _ref.read(sightingsRepositoryProvider);

    await repository.updateSighting(
      sightingId: sightingId,
      editedByUserId: currentUser.uid,
      playerName: playerName,
      playerId: playerId,
      platform: platform,
      sharingScope: sharingScope,
      note: note,
    );

    _ref.invalidate(rawServerSightingsProvider(serverId));
    _ref.invalidate(serverSightingsProvider(serverId));
    _ref.invalidate(sightingHistoryProvider(sightingId));
  }
}
