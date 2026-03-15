// features/servers/domain/server.dart
class Server {
  final String id;
  final String name;
  final String map;
  final int players;
  final int maxPlayers;
  final bool official;

  const Server({
    required this.id,
    required this.name,
    required this.map,
    required this.players,
    required this.maxPlayers,
    required this.official,
  });
}
