// features/notifications/data/repositories/fcm_token_repository.dart
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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

    await _tokensCollection(userId).doc(_tokenDocumentId(normalizedToken)).set({
      'token': normalizedToken,
      'platform': defaultTargetPlatform.name,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeToken({
    required String userId,
    required String token,
  }) async {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      return;
    }

    await _tokensCollection(userId).doc(_tokenDocumentId(normalizedToken)).delete();
  }

  String _tokenDocumentId(String token) {
    return base64UrlEncode(utf8.encode(token));
  }
}
