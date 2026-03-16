// features/favorites/presentation/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../servers/presentation/providers/server_providers.dart';
import '../../../servers/presentation/screens/server_detail_screen.dart';
import '../favorites_controller.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesControllerProvider);
    final serversAsync = ref.watch(serversProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: serversAsync.when(
        data: (servers) {
          final favoriteServers = servers
              .where((server) => favoriteIds.contains(server.id))
              .toList();

          if (favoriteServers.isEmpty) {
            return const Center(child: Text('No favorites yet'));
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
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text('Remove favorite'),
                            content: Text(
                              'Do you want to remove "${server.name}" from favorites?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop(false);
                                },
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop(true);
                                },
                                child: const Text('Remove'),
                              ),
                            ],
                          );
                        },
                      ) ??
                      false;
                },
                onDismissed: (_) {
                  ref
                      .read(favoritesControllerProvider.notifier)
                      .toggleFavorite(server.id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${server.name} removed from favorites'),
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
                        builder: (_) => ServerDetailScreen(serverId: server.id),
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
            child: Text(error.toString()),
          ),
        ),
      ),
    );
  }
}
