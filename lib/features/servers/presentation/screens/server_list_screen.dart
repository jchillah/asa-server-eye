// features/servers/presentation/screens/server_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/server_providers.dart';
import 'server_detail_screen.dart';

class ServerListScreen extends ConsumerWidget {
  const ServerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serversAsync = ref.watch(serversProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Servers')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(serversProvider);
          await ref.read(serversProvider.future);
        },
        child: serversAsync.when(
          data: (servers) {
            if (servers.isEmpty) {
              return ListView(
                children: [
                  SizedBox(height: 250),
                  Center(child: Text('No servers found')),
                ],
              );
            }

            return ListView.builder(
              itemCount: servers.length,
              itemBuilder: (context, index) {
                final server = servers[index];

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
          error: (error, stackTrace) => ListView(
            children: [
              const SizedBox(height: 250),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(error.toString()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
