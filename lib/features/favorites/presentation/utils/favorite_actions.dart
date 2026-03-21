// features/favorites/presentation/utils/favorite_actions.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/extensions/context_l10n.dart';
import '../controllers/favorites_controller.dart';

abstract final class FavoriteActions {
  static Future<void> toggleFavorite({
    required BuildContext context,
    required WidgetRef ref,
    required String serverId,
    required bool isFavorite,
  }) async {
    try {
      await ref.read(favoritesControllerProvider).toggleFavorite(serverId);

      if (!context.mounted) return;

      final message = isFavorite
          ? context.l10n.removedFromFavorites
          : context.l10n.addedToFavorites;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.genericError)));
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
      await ref.read(favoritesControllerProvider).removeFavorite(serverId);
      return true;
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.genericError)));
      }
      return false;
    }
  }

  static void showRemovedMessage({
    required BuildContext context,
    required String serverName,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.removedServerFromFavorites(serverName)),
      ),
    );
  }
}
