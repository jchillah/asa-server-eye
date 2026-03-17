// features/favorites/presentation/favorites_controller.dart
import 'package:ark_server_eye/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/favorites_repository.dart';

final favoriteIdsProvider = StreamProvider<List<String>>((ref) {
  final user = ref.watch(currentUserProvider);

  if (user == null) {
    return Stream.value(const <String>[]);
  }

  final repository = ref.watch(favoritesRepositoryProvider);
  return repository.watchFavoriteIds(user.uid);
});

final favoritesControllerProvider = Provider<FavoritesController>((ref) {
  return FavoritesController(ref);
});

class FavoritesController {
  FavoritesController(this._ref);

  final Ref _ref;

  Future<void> toggleFavorite(String serverId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      throw StateError('User is not authenticated.');
    }

    final favoriteIds = await _ref.read(favoriteIdsProvider.future);
    final repository = _ref.read(favoritesRepositoryProvider);

    if (favoriteIds.contains(serverId)) {
      await repository.removeFavorite(userId: user.uid, serverId: serverId);
    } else {
      await repository.saveFavorite(userId: user.uid, serverId: serverId);
    }
  }

  Future<void> removeFavorite(String serverId) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) {
      throw StateError('User is not authenticated.');
    }

    final repository = _ref.read(favoritesRepositoryProvider);
    await repository.removeFavorite(userId: user.uid, serverId: serverId);
  }
}
