// features/favorites/presentation/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../../servers/presentation/providers/server_providers.dart';
import '../../../servers/presentation/screens/server_detail_screen.dart';
import '../favorites_controller.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIdsAsync = ref.watch(favoriteIdsProvider);
    final serversAsync = ref.watch(serversProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.favorites)),
      body: favoriteIdsAsync.when(
        data: (favoriteIds) {
          return serversAsync.when(
            data: (servers) {
              final favoriteServers = servers
                  .where((server) => favoriteIds.contains(server.id))
                  .toList();

              if (favoriteServers.isEmpty) {
                return Center(child: Text(context.l10n.noFavoritesYet));
              }

              return ListView.builder(
                itemCount: favoriteServers.length,
                itemBuilder: (context, index) {
                  final server = favoriteServers[index];

                  return Dismissible(
                    key: ValueKey(server.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (_) async {
                      final shouldRemove =
                          await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: Text(context.l10n.removeFavorite),
                                content: Text(
                                  context.l10n.removeFavoriteQuestion(
                                    server.name,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(false);
                                    },
                                    child: Text(context.l10n.cancel),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(true);
                                    },
                                    child: Text(context.l10n.remove),
                                  ),
                                ],
                              );
                            },
                          ) ??
                          false;

                      if (!shouldRemove) {
                        return false;
                      }

                      try {
                        await ref
                            .read(favoritesControllerProvider)
                            .removeFavorite(server.id);
                        return true;
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.l10n.genericError)),
                          );
                        }
                        return false;
                      }
                    },
                    onDismissed: (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.l10n.removedServerFromFavorites(
                              server.name,
                            ),
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(server.name),
                      subtitle: Text(
                        '${server.map} • ${server.players}/${server.maxPlayers}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ServerDetailScreen(serverId: server.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(context.l10n.genericError),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(context.l10n.genericError),
          ),
        ),
      ),
    );
  }
}
