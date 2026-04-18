// features/favorites/data/favorites_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository(FirebaseFirestore.instance);
});

class FavoritesRepository {
  FavoritesRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String userId) {
    return _firestore.collection('users').doc(userId);
  }

  Stream<List<String>> watchFavoriteIds(String userId) {
    return _userDoc(userId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        return <String>[];
      }

      final favoriteIds = data['favoriteIds'];
      if (favoriteIds is! List) {
        return <String>[];
      }

      return favoriteIds.whereType<String>().toList(growable: false);
    });
  }

  Future<void> saveFavorite({
    required String userId,
    required String serverId,
  }) async {
    await _userDoc(userId).set({
      'favoriteIds': FieldValue.arrayUnion([serverId]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeFavorite({
    required String userId,
    required String serverId,
  }) async {
    await _userDoc(userId).set({
      'favoriteIds': FieldValue.arrayRemove([serverId]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
