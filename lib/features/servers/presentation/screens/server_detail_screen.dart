// features/servers/presentation/screens/server_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../favorites/presentation/favorites_controller.dart';
import '../../domain/server.dart';

class ServerDetailScreen extends ConsumerWidget {
  const ServerDetailScreen({super.key, required this.server});

  final Server server;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesControllerProvider);
    final isFavorite = favorites.contains(server.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Server Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(server.name, style: Theme.of(context).textTheme.headlineSmall),
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
      ),
    );
  }
}
