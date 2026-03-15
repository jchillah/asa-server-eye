// features/servers/presentation/screens/server_list_screen.dart
import 'package:flutter/material.dart';

import '../../data/server_service.dart';
import '../../domain/server.dart';

class ServerListScreen extends StatefulWidget {
  const ServerListScreen({super.key});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> {
  final service = ServerService();
  late Future<List<Server>> servers;

  @override
  void initState() {
    super.initState();
    servers = service.fetchServers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Servers")),
      body: FutureBuilder<List<Server>>(
        future: servers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data ?? [];

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final server = data[index];

              return ListTile(
                title: Text(server.name),
                subtitle: Text(
                  "${server.map} • ${server.players}/${server.maxPlayers}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
