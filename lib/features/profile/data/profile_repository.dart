// features/profile/data/profile_repository.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../domain/app_user_profile.dart';

class ProfileRepository {
  ProfileRepository(this._firestore, this._auth, this._storage);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  User get _currentUser {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user found.');
    }
    return user;
  }

  DocumentReference<Map<String, dynamic>> get _userDoc {
    return _firestore.collection('users').doc(_currentUser.uid);
  }

  Stream<AppUserProfile?> watchProfile() {
    return _userDoc.snapshots().map((doc) {
      final data = doc.data();
      if (data == null) {
        return null;
      }

      return AppUserProfile.fromMap(doc.id, data);
    });
  }

  Future<String> uploadProfileImage(File file) async {
    final ref = _storage.ref().child('users/${_currentUser.uid}/profile.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<void> updateProfile({
    required AppUserProfile currentProfile,
    required String username,
    String? newPhotoUrl,
  }) async {
    final normalizedUsername = username.trim();
    final resolvedPhotoUrl = newPhotoUrl ?? currentProfile.photoUrl;

    await _currentUser.updateDisplayName(normalizedUsername);

    if (resolvedPhotoUrl != null) {
      await _currentUser.updatePhotoURL(resolvedPhotoUrl);
    }

    await _userDoc.update({
      'username': normalizedUsername,
      'usernameLower': normalizedUsername.toLowerCase(),
      'email': currentProfile.email,
      'photoUrl': resolvedPhotoUrl,
      'favoriteIds': currentProfile.favoriteIds,
      'sightingsAccessLevel': currentProfile.sightingsAccessLevel,
      'createdAt': currentProfile.createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final credential = EmailAuthProvider.credential(
      email: email.trim(),
      password: password,
    );

    await _currentUser.reauthenticateWithCredential(credential);

    try {
      await _storage
          .ref()
          .child('users/${_currentUser.uid}/profile.jpg')
          .delete();
    } catch (_) {}

    await _userDoc.delete();
    await _currentUser.delete();
  }
}
