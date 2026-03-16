// features/settings/servers/presentation/screens/server_detail_screen.dart
import 'package:ark_server_eye/features/favorites/presentation/favorites_controller.dart';
import 'package:ark_server_eye/features/settings/servers/domain/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/server_providers.dart';

class ServerDetailScreen extends ConsumerWidget {
  const ServerDetailScreen({super.key, required this.serverId});

  final String serverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesControllerProvider);
    final isFavorite = favorites.contains(serverId);
    final serversAsync = ref.watch(serversProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Server Details')),
      body: serversAsync.when(
        data: (servers) {
          final server = _findServerById(servers, serverId);

          if (server == null) {
            return const Center(child: Text('Server not found'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                server.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Map'),
                subtitle: Text(server.map),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Population'),
                subtitle: Text('${server.players}/${server.maxPlayers}'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Type'),
                subtitle: Text(server.official ? 'Official' : 'Unofficial'),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  ref
                      .read(favoritesControllerProvider.notifier)
                      .toggleFavorite(server.id);

                  final message = isFavorite
                      ? 'Removed from favorites'
                      : 'Added to favorites';

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(message)));
                },
                icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                label: Text(
                  isFavorite ? 'Remove from favorites' : 'Add to favorites',
                ),
              ),
            ],
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

  Server? _findServerById(List<Server> servers, String serverId) {
    for (final server in servers) {
      if (server.id == serverId) {
        return server;
      }
    }
    return null;
  }
}
