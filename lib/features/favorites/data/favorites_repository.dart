// features/favorites/data/favorites_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository(FirebaseFirestore.instance);
});

class FavoritesRepository {
  FavoritesRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _favoritesCollection(
    String userId,
  ) {
    return _firestore.collection('users').doc(userId).collection('favorites');
  }

  Stream<List<String>> watchFavoriteIds(String userId) {
    return _favoritesCollection(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> saveFavorite({
    required String userId,
    required String serverId,
  }) async {
    await _favoritesCollection(userId).doc(serverId).set({
      'serverId': serverId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFavorite({
    required String userId,
    required String serverId,
  }) async {
    await _favoritesCollection(userId).doc(serverId).delete();
  }
}
