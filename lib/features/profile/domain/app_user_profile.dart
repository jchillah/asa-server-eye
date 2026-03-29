// features/profile/domain/app_user_profile.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserProfile {
  const AppUserProfile({
    required this.id,
    required this.username,
    required this.usernameLower,
    required this.email,
    required this.photoUrl,
    required this.favoriteIds,
    required this.sightingsAccessLevel,
    required this.createdAt,
  });

  final String id;
  final String username;
  final String usernameLower;
  final String email;
  final String? photoUrl;
  final List<String> favoriteIds;
  final String sightingsAccessLevel;
  final Timestamp? createdAt;

  factory AppUserProfile.fromMap(String id, Map<String, dynamic> map) {
    return AppUserProfile(
      id: id,
      username: (map['username'] as String?) ?? '',
      usernameLower: (map['usernameLower'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      photoUrl: map['photoUrl'] as String?,
      favoriteIds: (map['favoriteIds'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      sightingsAccessLevel: (map['sightingsAccessLevel'] as String?) ?? 'free',
      createdAt: map['createdAt'] as Timestamp?,
    );
  }
}
