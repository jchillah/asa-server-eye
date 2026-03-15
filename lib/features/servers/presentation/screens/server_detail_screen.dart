// features/servers/presentation/screens/server_detail_screen.dart
import 'package:flutter/material.dart';

import '../../domain/server.dart';

class ServerDetailScreen extends StatelessWidget {
  const ServerDetailScreen({super.key, required this.server});

  final Server server;

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }
}
