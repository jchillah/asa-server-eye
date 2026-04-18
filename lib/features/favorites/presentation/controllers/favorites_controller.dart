// features/favorites/presentation/controllers/favorites_controller.dart
import 'dart:async';

import 'package:asa_server_eye/features/auth/presentation/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_logger.dart';
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

  StreamSubscription<List<String>>? _subscription;
  final Set<String> _pendingServerIds = <String>{};

  void _init() {
    final userId = _userId;

    if (userId == null) {
      state = const AsyncValue.data(<String>[]);
      return;
    }

    _subscription = _repository
        .watchFavoriteIds(userId)
        .listen(
          (ids) {
            state = AsyncValue.data(ids);
          },
          onError: (error, stackTrace) {
            state = AsyncValue.error(error, stackTrace);
          },
        );
  }

  Future<void> toggle(String serverId) async {
    final currentIds = List<String>.from(state.valueOrNull ?? const <String>[]);

    if (currentIds.contains(serverId)) {
      await removeFavorite(serverId);
      return;
    }

    await addFavorite(serverId);
  }

  Future<void> addFavorite(String serverId) async {
    await _mutateFavorite(
      serverId: serverId,
      mutate: (currentIds) {
        if (currentIds.contains(serverId)) {
          return currentIds;
        }

        return <String>[...currentIds, serverId];
      },
      remoteWrite: (userId) {
        return _repository.saveFavorite(userId: userId, serverId: serverId);
      },
    );
  }

  Future<void> removeFavorite(String serverId) async {
    await _mutateFavorite(
      serverId: serverId,
      mutate: (currentIds) {
        if (!currentIds.contains(serverId)) {
          return currentIds;
        }

        return currentIds.where((id) => id != serverId).toList(growable: false);
      },
      remoteWrite: (userId) {
        return _repository.removeFavorite(userId: userId, serverId: serverId);
      },
    );
  }

  Future<void> _mutateFavorite({
    required String serverId,
    required List<String> Function(List<String> currentIds) mutate,
    required Future<void> Function(String userId) remoteWrite,
  }) async {
    final userId = _userId;

    if (userId == null) {
      throw StateError('User not logged in');
    }

    if (serverId.trim().isEmpty) {
      throw ArgumentError('Server ID is empty');
    }

    if (_pendingServerIds.contains(serverId)) {
      AppLogger.warning(
        'FavoriteIdsNotifier',
        'Ignored duplicate favorite request while operation is pending for serverId=$serverId.',
      );
      return;
    }

    _pendingServerIds.add(serverId);

    final previousIds = List<String>.from(
      state.valueOrNull ?? const <String>[],
    );
    final nextIds = mutate(previousIds);

    state = AsyncValue.data(nextIds);

    try {
      await remoteWrite(userId);
    } catch (error, stackTrace) {
      state = AsyncValue.data(previousIds);

      AppLogger.error(
        'FavoriteIdsNotifier',
        'Failed to update favorite state for serverId=$serverId.',
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    } finally {
      _pendingServerIds.remove(serverId);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
