// features/profile/data/repositories/profile_repository.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/app_user_profile.dart';

class ProfileRepository {
  ProfileRepository(
    this._firestore,
    this._auth,
    this._storage,
    this._functions,
  );

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  final FirebaseFunctions _functions;

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
        return _buildFallbackProfile(user);
      }

      return AppUserProfile.fromMap(doc.id, data);
    });
  }

  AppUserProfile _buildFallbackProfile(User user) {
    final resolvedEmail = (user.email ?? '').trim().toLowerCase();
    final resolvedUsername = (user.displayName ?? '').trim().isNotEmpty
        ? user.displayName!.trim()
        : _usernameFromEmail(resolvedEmail);

    return AppUserProfile(
      id: user.uid,
      username: resolvedUsername,
      usernameLower: resolvedUsername.toLowerCase(),
      email: resolvedEmail,
      photoUrl: user.photoURL,
      favoriteIds: const <String>[],
      sightingsAccessLevel: 'free',
      createdAt: null,
    );
  }

  String _usernameFromEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex <= 0) {
      return 'Player';
    }

    final candidate = email.substring(0, atIndex).trim();
    if (candidate.isEmpty) {
      return 'Player';
    }

    return candidate;
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
    final normalizedEmail = currentProfile.email.trim().isNotEmpty
        ? currentProfile.email.trim().toLowerCase()
        : (user.email ?? '').trim().toLowerCase();
    final resolvedPhotoUrl = newPhotoUrl ?? currentProfile.photoUrl;

    await user.updateDisplayName(normalizedUsername);

    if (user.photoURL != resolvedPhotoUrl) {
      await user.updatePhotoURL(resolvedPhotoUrl);
    }

    await _userDoc(user.uid).set({
      'username': normalizedUsername,
      'usernameLower': normalizedUsername.toLowerCase(),
      'email': normalizedEmail,
      'photoUrl': resolvedPhotoUrl,
      'favoriteIds': currentProfile.favoriteIds,
      'sightingsAccessLevel': currentProfile.sightingsAccessLevel,
      'createdAt': currentProfile.createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final user = _currentUser;
    final normalizedEmail = email.trim().toLowerCase();
    final credential = EmailAuthProvider.credential(
      email: normalizedEmail,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
    await user.getIdToken(true);

    final result = await _functions
        .httpsCallable('deleteAccount')
        .call<Map<Object?, Object?>>();
    final data = result.data;
    if (data['deleted'] != true) {
      throw StateError('Account deletion was not confirmed by the server.');
    }
  }
}
