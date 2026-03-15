// features/favorites/presentation/favorites_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesControllerProvider =
    StateNotifierProvider<FavoritesController, List<String>>((ref) {
      return FavoritesController();
    });

class FavoritesController extends StateNotifier<List<String>> {
  FavoritesController() : super(const []);

  bool isFavorite(String serverId) => state.contains(serverId);

  void toggleFavorite(String serverId) {
    if (state.contains(serverId)) {
      state = state.where((id) => id != serverId).toList();
    } else {
      state = [...state, serverId];
    }
  }
}
