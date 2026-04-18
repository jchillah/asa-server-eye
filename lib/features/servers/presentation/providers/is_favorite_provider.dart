// features/servers/presentation/providers/is_favorite_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../favorites/presentation/controllers/favorites_controller.dart';

final isFavoriteServerProvider = Provider.family<AsyncValue<bool>, String>((
  ref,
  serverId,
) {
  final favoriteIdsAsync = ref.watch(favoriteIdsProvider);

  return favoriteIdsAsync.whenData((favoriteIds) {
    return favoriteIds.contains(serverId);
  });
});
