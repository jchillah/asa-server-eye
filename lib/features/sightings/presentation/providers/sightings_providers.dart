// features/sightings/presentation/providers/sightings_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/sightings_repository.dart';
import '../../domain/player_sighting.dart';
import '../../domain/sighting_change_log.dart';
import '../../domain/sightings_visibility_policy.dart';
import 'sightings_access_providers.dart';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final sightingsRepositoryProvider = Provider<SightingsRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return SightingsRepository(firestore);
});

final rawServerSightingsProvider = FutureProvider.autoDispose
    .family<List<PlayerSighting>, String>((ref, serverId) async {
      final repository = ref.watch(sightingsRepositoryProvider);
      return repository.fetchSightingsByServerId(serverId);
    });

final serverSightingsProvider = FutureProvider.autoDispose
    .family<List<PlayerSighting>, String>((ref, serverId) async {
      final sightings = await ref.watch(
        rawServerSightingsProvider(serverId).future,
      );
      final accessLevel = await ref.watch(sightingsAccessLevelProvider.future);
      final currentUser = ref.watch(currentUserProvider);

      return SightingsVisibilityPolicy.filterSightings(
        sightings: sightings,
        accessLevel: accessLevel,
        currentUserId: currentUser?.uid,
      );
    });

final sightingHistoryProvider = FutureProvider.autoDispose
    .family<List<SightingChangeLog>, String>((ref, sightingId) async {
      final repository = ref.watch(sightingsRepositoryProvider);
      return repository.fetchHistoryBySightingId(sightingId);
    });
