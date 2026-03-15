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

              return ListTile(
                title: Text(server.name),
                subtitle: Text(
                  '${server.map} • ${server.players}/${server.maxPlayers}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ServerDetailScreen(server: server),
                    ),
                  );
                },
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
