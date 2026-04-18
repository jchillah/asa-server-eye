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

final serverSightingsProvider = FutureProvider.autoDispose
    .family<List<PlayerSighting>, String>((ref, serverId) async {
      final repository = ref.watch(sightingsRepositoryProvider);
      final accessLevel = await ref.watch(sightingsAccessLevelProvider.future);
      final currentUserId = ref.watch(currentUserIdProvider);

      if (currentUserId == null) {
        return const <PlayerSighting>[];
      }

      switch (accessLevel) {
        case SightingsAccessLevel.free:
          final ownSightings = await repository.fetchOwnSightingsByServerId(
            serverId: serverId,
            userId: currentUserId,
          );

          ownSightings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return ownSightings;

        case SightingsAccessLevel.premium:
          final results = await Future.wait([
            repository.fetchOwnSightingsByServerId(
              serverId: serverId,
              userId: currentUserId,
            ),
            repository.fetchPremiumSharedSightingsByServerId(serverId),
          ]);

          final mergedById = <String, PlayerSighting>{};

          for (final sighting in results.expand((list) => list)) {
            mergedById[sighting.id] = sighting;
          }

          final merged = mergedById.values.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return merged;

        case SightingsAccessLevel.admin:
          final allSightings = await repository.fetchAllSightingsByServerId(
            serverId,
          );

          allSightings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return allSightings;
      }
    });

final sightingHistoryProvider = FutureProvider.autoDispose
    .family<List<SightingChangeLog>, String>((ref, sightingId) async {
      final repository = ref.watch(sightingsRepositoryProvider);
      return repository.fetchHistoryBySightingId(sightingId);
    });
