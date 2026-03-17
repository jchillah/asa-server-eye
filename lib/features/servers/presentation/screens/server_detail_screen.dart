// features/servers/presentation/screens/server_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../../favorites/presentation/favorites_controller.dart';
import '../../domain/server.dart';
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
      appBar: AppBar(title: Text(context.l10n.serverDetails)),
      body: serversAsync.when(
        data: (servers) {
          final server = _findServerById(servers, serverId);

          if (server == null) {
            return Center(child: Text(context.l10n.serverNotFound));
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
                title: Text(context.l10n.map),
                subtitle: Text(server.map),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.population),
                subtitle: Text('${server.players}/${server.maxPlayers}'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.type),
                subtitle: Text(
                  server.official
                      ? context.l10n.official
                      : context.l10n.unofficial,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  ref
                      .read(favoritesControllerProvider.notifier)
                      .toggleFavorite(server.id);

                  final message = isFavorite
                      ? context.l10n.removedFromFavorites
                      : context.l10n.addedToFavorites;

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(message)));
                },
                icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                label: Text(
                  isFavorite
                      ? context.l10n.removeFromFavorites
                      : context.l10n.addToFavorites,
                ),
              ),
            ],
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

  Server? _findServerById(List<Server> servers, String serverId) {
    for (final server in servers) {
      if (server.id == serverId) {
        return server;
      }
    }
    return null;
  }
}
