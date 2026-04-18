// features/sightings/presentation/providers/sightings_access_providers.dart
import 'package:asa_server_eye/features/auth/presentation/providers/current_user_provider.dart';
import 'package:asa_server_eye/features/auth/presentation/providers/firestore_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/sightings_user_profile_model.dart';
import '../../domain/sightings_access_level.dart';

final sightingsUserProfileProvider =
    FutureProvider.autoDispose<SightingsUserProfileModel?>((ref) async {
      final currentUser = ref.watch(currentUserProvider);

      if (currentUser == null) {
        return null;
      }

      final firestore = ref.watch(firestoreProvider);
      final doc = await firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!doc.exists) {
        return null;
      }

      return SightingsUserProfileModel.fromFirestore(doc);
    });

final sightingsAccessLevelProvider =
    FutureProvider.autoDispose<SightingsAccessLevel>((ref) async {
      final profile = await ref.watch(sightingsUserProfileProvider.future);
      return profile?.accessLevel ?? SightingsAccessLevel.free;
    });
