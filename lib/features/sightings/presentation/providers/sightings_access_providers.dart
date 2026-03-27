// features/sightings/presentation/providers/sightings_access_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/models/sightings_user_profile_model.dart';
import '../../domain/sightings_access_level.dart';

final sightingsAccessLevelProvider =
    FutureProvider.autoDispose<SightingsAccessLevel>((ref) async {
      final currentUser = ref.watch(currentUserProvider);

      if (currentUser == null) {
        return SightingsAccessLevel.free;
      }

      final firestore = FirebaseFirestore.instance;
      final doc = await firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!doc.exists) {
        return SightingsAccessLevel.free;
      }

      final profile = SightingsUserProfileModel.fromFirestore(doc);
      return profile.accessLevel;
    });
