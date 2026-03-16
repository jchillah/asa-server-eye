// features/servers/presentation/screens/server_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../providers/server_providers.dart';
import 'server_detail_screen.dart';

class ServerListScreen extends ConsumerStatefulWidget {
  const ServerListScreen({super.key});

  @override
  ConsumerState<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends ConsumerState<ServerListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serversAsync = ref.watch(serversProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.servers)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _query = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: context.l10n.searchServersOrMaps,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _query = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(serversProvider);
                await ref.read(serversProvider.future);
              },
              child: serversAsync.when(
                data: (servers) {
                  final filteredServers = servers.where((server) {
                    if (_query.isEmpty) return true;

                    final name = server.name.toLowerCase();
                    final map = server.map.toLowerCase();

                    return name.contains(_query) || map.contains(_query);
                  }).toList();

                  if (servers.isEmpty) {
                    return ListView(
                      children: [
                        const SizedBox(height: 250),
                        Center(child: Text(context.l10n.noServersFound)),
                      ],
                    );
                  }

                  if (filteredServers.isEmpty) {
                    return ListView(
                      children: [
                        const SizedBox(height: 250),
                        Center(
                          child: Text(
                            _query.isEmpty
                                ? context.l10n.noServersFound
                                : context.l10n.noServersMatchSearch,
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredServers.length,
                    itemBuilder: (context, index) {
                      final server = filteredServers[index];

                      return ListTile(
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
          ),
        ],
      ),
    );
  }
}
