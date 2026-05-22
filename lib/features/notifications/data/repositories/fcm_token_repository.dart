// features/notifications/data/repositories/fcm_token_repository.dart
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:flutter/foundation.dart';

class FcmTokenRepository {
  const FcmTokenRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _tokensCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('fcm_tokens');
  }

  Future<void> saveToken({
    required String userId,
    required String token,
  }) async {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      return;
    }

    final docRef = _tokensCollection(
      userId,
    ).doc(_tokenDocumentId(normalizedToken));
    final updateData = <String, dynamic>{
      'token': normalizedToken,
      'platform': _stablePlatformId,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      await docRef.update(updateData);
    } on FirebaseException catch (error) {
      if (error.code != 'not-found') {
        rethrow;
      }

      await docRef.set({
        ...updateData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> removeToken({
    required String userId,
    required String token,
  }) async {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      return;
    }

    await _tokensCollection(
      userId,
    ).doc(_tokenDocumentId(normalizedToken)).delete();
  }

  String get _stablePlatformId {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.fuchsia:
        return 'fuchsia';
    }
  }

  String _tokenDocumentId(String token) {
    return sha256.convert(utf8.encode(token)).toString();
  }
}
