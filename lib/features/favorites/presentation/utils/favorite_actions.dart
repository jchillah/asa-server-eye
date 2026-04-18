// features/favorites/presentation/utils/favorite_actions.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/extensions/context_l10n.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../sightings/domain/sightings_access_level.dart';
import '../../../sightings/presentation/providers/sightings_access_providers.dart';
import '../../domain/favorite_limit_policy.dart';
import '../controllers/favorites_controller.dart';

abstract final class FavoriteActions {
  static Future<void> toggleFavorite({
    required BuildContext context,
    required WidgetRef ref,
    required String serverId,
    required bool isFavorite,
  }) async {
    try {
      if (isFavorite) {
        await ref.read(favoriteIdsProvider.notifier).removeFavorite(serverId);

        if (!context.mounted) {
          return;
        }

        _showMessage(context, context.l10n.removedFromFavorites);
        return;
      }

      final canAdd = await _canAddFavorite(context: context, ref: ref);
      if (!canAdd) {
        return;
      }

      await ref.read(favoriteIdsProvider.notifier).addFavorite(serverId);

      if (!context.mounted) {
        return;
      }

      _showMessage(context, context.l10n.addedToFavorites);
    } catch (error, stackTrace) {
      AppLogger.error(
        'FavoriteActions',
        'Failed to toggle favorite.',
        error: error,
        stackTrace: stackTrace,
      );

      if (!context.mounted) {
        return;
      }

      _showMessage(context, context.l10n.genericError);
    }
  }

  static Future<bool> confirmRemoveFavorite({
    required BuildContext context,
    required String serverName,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text(context.l10n.removeFavorite),
              content: Text(context.l10n.removeFavoriteQuestion(serverName)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(context.l10n.cancel),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.white,
                  ),
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(context.l10n.remove),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  static Future<bool> removeFavorite({
    required BuildContext context,
    required WidgetRef ref,
    required String serverId,
    required String serverName,
  }) async {
    final shouldRemove = await confirmRemoveFavorite(
      context: context,
      serverName: serverName,
    );

    if (!shouldRemove) {
      return false;
    }

    try {
      await ref.read(favoriteIdsProvider.notifier).removeFavorite(serverId);
      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'FavoriteActions',
        'Failed to remove favorite.',
        error: error,
        stackTrace: stackTrace,
      );

      if (context.mounted) {
        _showMessage(context, context.l10n.genericError);
      }

      return false;
    }
  }

  static void showRemovedMessage({
    required BuildContext context,
    required String serverName,
  }) {
    _showMessage(context, context.l10n.removedServerFromFavorites(serverName));
  }

  static Future<bool> _canAddFavorite({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final favoriteIdsAsync = ref.read(favoriteIdsProvider);

    if (favoriteIdsAsync.isLoading) {
      if (context.mounted) {
        _showMessage(context, context.l10n.genericError);
      }
      return false;
    }

    if (favoriteIdsAsync.hasError) {
      throw favoriteIdsAsync.error!;
    }

    final favoriteIds = favoriteIdsAsync.valueOrNull ?? const <String>[];
    final accessLevel = await ref.read(sightingsAccessLevelProvider.future);
    final maxFavorites = FavoriteLimitPolicy.maxFavoritesFor(accessLevel);

    if (favoriteIds.length < maxFavorites) {
      return true;
    }

    if (!context.mounted) {
      return false;
    }

    final message = accessLevel == SightingsAccessLevel.free
        ? context.l10n.premiumRequiredForMoreFavorites
        : context.l10n.genericError;

    _showMessage(context, message);
    return false;
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
