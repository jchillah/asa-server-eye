// features/sightings/presentation/providers/sightings_providers.dart
import 'package:asa_server_eye/features/auth/presentation/providers/current_user_provider.dart';
import 'package:asa_server_eye/features/auth/presentation/providers/firestore_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/sightings_repository.dart';
import '../../domain/player_sighting.dart';
import '../../domain/sighting_change_log.dart';
import '../../domain/sightings_access_level.dart';
import 'sightings_access_providers.dart';

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(currentUserProvider)?.uid;
});

final sightingsRepositoryProvider = Provider<SightingsRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return SightingsRepository(firestore);
});

final serverSightingsProvider = StreamProvider.autoDispose
    .family<List<PlayerSighting>, String>((ref, serverId) async* {
      final repository = ref.watch(sightingsRepositoryProvider);
      final accessLevel = await ref.watch(sightingsAccessLevelProvider.future);
      final currentUserId = ref.watch(currentUserIdProvider);

      if (currentUserId == null) {
        yield const <PlayerSighting>[];
        return;
      }

      switch (accessLevel) {
        case SightingsAccessLevel.free:
          yield* repository.watchOwnSightingsByServerId(
            serverId: serverId,
            userId: currentUserId,
          );

        case SightingsAccessLevel.premium:
          yield* repository.watchVisibleOwnAndPremiumSharedSightingsByServerId(
            serverId: serverId,
            userId: currentUserId,
          );

        case SightingsAccessLevel.admin:
          yield* repository.watchAllSightingsByServerId(serverId);
      }
    });

final sightingsOverviewProvider =
    StreamProvider.autoDispose<List<PlayerSighting>>((ref) async* {
      final repository = ref.watch(sightingsRepositoryProvider);
      final accessLevel = await ref.watch(sightingsAccessLevelProvider.future);
      final currentUserId = ref.watch(currentUserIdProvider);

      if (currentUserId == null) {
        yield const <PlayerSighting>[];
        return;
      }

      switch (accessLevel) {
        case SightingsAccessLevel.free:
        case SightingsAccessLevel.premium:
          yield* repository.watchOwnSightings(userId: currentUserId);

        case SightingsAccessLevel.admin:
          yield* repository.watchAllSightings();
      }
    });

final sightingHistoryProvider = FutureProvider.autoDispose
    .family<List<SightingChangeLog>, String>((ref, sightingId) async {
      final repository = ref.watch(sightingsRepositoryProvider);
      return repository.fetchHistoryBySightingId(sightingId);
    });
