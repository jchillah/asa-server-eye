// features/profile/data/repositories/profile_repository.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/app_user_profile.dart';

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

  DocumentReference<Map<String, dynamic>> _userDoc(String userId) {
    return _firestore.collection('users').doc(userId);
  }

  Stream<AppUserProfile?> watchProfile() {
    final user = _currentUser;

    return _userDoc(user.uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) {
        return null;
      }

      return AppUserProfile.fromMap(doc.id, data);
    });
  }

  Future<String> uploadProfileImage(File file) async {
    final user = _currentUser;
    final ref = _storage.ref().child('users/${user.uid}/profile.jpg');

    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<void> updateProfile({
    required AppUserProfile currentProfile,
    required String username,
    String? newPhotoUrl,
  }) async {
    final user = _currentUser;
    final normalizedUsername = username.trim();
    final resolvedPhotoUrl = newPhotoUrl ?? currentProfile.photoUrl;

    await user.updateDisplayName(normalizedUsername);

    if (user.photoURL != resolvedPhotoUrl) {
      await user.updatePhotoURL(resolvedPhotoUrl);
    }

    await _userDoc(user.uid).update({
      'username': normalizedUsername,
      'usernameLower': normalizedUsername.toLowerCase(),
      'photoUrl': resolvedPhotoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final user = _currentUser;
    final normalizedEmail = email.trim().toLowerCase();
    final userDoc = _userDoc(user.uid);
    final imageRef = _storage.ref().child('users/${user.uid}/profile.jpg');

    final credential = EmailAuthProvider.credential(
      email: normalizedEmail,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);

    try {
      await imageRef.delete();
    } catch (_) {}

    await userDoc.delete();
    await user.delete();
  }
}
