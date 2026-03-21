// features/favorites/presentation/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../../servers/presentation/utils/server_navigation.dart';
import '../providers/favorite_servers_provider.dart';
import '../utils/favorite_actions.dart';
import '../widgets/favorite_server_list_item.dart';
import '../widgets/favorites_remove_background.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteServersAsync = ref.watch(favoriteServersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.favorites)),
      body: favoriteServersAsync.when(
        data: (favoriteServers) {
          if (favoriteServers.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  context.l10n.noFavoritesYet,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteServers.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final server = favoriteServers[index];

              return Dismissible(
                key: ValueKey(server.id),
                direction: DismissDirection.endToStart,
                background: const FavoritesRemoveBackground(),
                confirmDismiss: (_) => FavoriteActions.removeFavorite(
                  context: context,
                  ref: ref,
                  serverId: server.id,
                  serverName: server.name,
                ),
                onDismissed: (_) => FavoriteActions.showRemovedMessage(
                  context: context,
                  serverName: server.name,
                ),
                child: FavoriteServerListItem(
                  server: server,
                  onTap: () => ServerNavigation.openDetails(context, server.id),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(context.l10n.genericError, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
