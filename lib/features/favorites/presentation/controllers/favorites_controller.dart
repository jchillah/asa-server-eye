// features/favorites/presentation/controllers/favorites_controller.dart
import 'dart:async';

import 'package:asa_server_eye/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/favorites_repository.dart';

final favoriteIdsProvider =
    StateNotifierProvider<FavoriteIdsNotifier, AsyncValue<List<String>>>((ref) {
      final repository = ref.watch(favoritesRepositoryProvider);
      final user = ref.watch(currentUserProvider);

      return FavoriteIdsNotifier(repository, user?.uid);
    });

class FavoriteIdsNotifier extends StateNotifier<AsyncValue<List<String>>> {
  FavoriteIdsNotifier(this._repository, this._userId)
    : super(const AsyncValue.loading()) {
    _init();
  }

  final FavoritesRepository _repository;
  final String? _userId;

  StreamSubscription<List<String>>? _sub;

  void _init() {
    final userId = _userId;

    if (userId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    _sub = _repository
        .watchFavoriteIds(userId)
        .listen(
          (ids) {
            state = AsyncValue.data(ids);
          },
          onError: (e, st) {
            state = AsyncValue.error(e, st);
          },
        );
  }

  Future<void> toggle(String serverId) async {
    final userId = _userId;

    if (userId == null) {
      throw StateError('User not logged in');
    }

    if (serverId.isEmpty) {
      throw ArgumentError('Server ID is empty');
    }

    final current = state.value ?? [];
    final isFavorite = current.contains(serverId);

    final updated = isFavorite
        ? current.where((id) => id != serverId).toList()
        : [...current, serverId];

    state = AsyncValue.data(updated);

    try {
      if (isFavorite) {
        await _repository.removeFavorite(userId: userId, serverId: serverId);
      } else {
        await _repository.saveFavorite(userId: userId, serverId: serverId);
      }
    } catch (e) {
      state = AsyncValue.data(current);
      rethrow;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
