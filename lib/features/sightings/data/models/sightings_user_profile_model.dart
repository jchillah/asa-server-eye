// features/sightings/data/models/sightings_user_profile_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/sightings_access_level.dart';

class SightingsUserProfileModel {
  const SightingsUserProfileModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.accessLevel,
  });

  final String userId;
  final String username;
  final String email;
  final SightingsAccessLevel accessLevel;

  factory SightingsUserProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};

    return SightingsUserProfileModel(
      userId: doc.id,
      username: data['username']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
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
