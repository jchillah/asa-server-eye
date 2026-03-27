// features/sightings/data/models/sightings_user_profile_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/sightings_access_level.dart';

class SightingsUserProfileModel {
  const SightingsUserProfileModel({
    required this.userId,
    required this.accessLevel,
  });

  final String userId;
  final SightingsAccessLevel accessLevel;

  factory SightingsUserProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};

    return SightingsUserProfileModel(
      userId: doc.id,
      accessLevel: _accessLevelFromString(data['sightingsAccessLevel']),
    );
  }

  static SightingsAccessLevel _accessLevelFromString(dynamic value) {
    final normalized = value?.toString().trim().toLowerCase();

    switch (normalized) {
      case 'premium':
        return SightingsAccessLevel.premium;
      case 'admin':
        return SightingsAccessLevel.admin;
      default:
        return SightingsAccessLevel.free;
    }
  }
}
