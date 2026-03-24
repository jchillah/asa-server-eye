// features/servers/domain/server.dart
class Server {
  const Server({
    required this.id,
    required this.name,
    required this.map,
    required this.players,
    required this.maxPlayers,
    required this.official,
  });

  final String id;
  final String name;
  final String map;
  final int players;
  final int maxPlayers;
  final bool official;

  factory Server.fromJson(Map<String, dynamic> json) {
    final resolvedId = _readString(json, const [
      'SessionID',
      'SessionId',
      'SessionID64',
    ]);

    return Server(
      id: resolvedId,
      name: _readString(json, const ['Name'], fallback: 'Unknown Server'),
      map: _readString(json, const ['MapName'], fallback: 'Unknown Map'),
      players: _readInt(json, const ['NumPlayers']),
      maxPlayers: _readInt(json, const ['MaxPlayers']),
      official: _readBool(json, const ['IsOfficial', 'Official']),
    );
  }

  static String _readString(
    Map<String, dynamic> json,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) {
        continue;
      }

      final asString = value.toString().trim();
      if (asString.isNotEmpty) {
        return asString;
      }
    }

    return fallback;
  }

  static int _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];

      if (value is int) {
        return value;
      }

      if (value is double) {
        return value.toInt();
      }

      if (value is String) {
        final parsed = int.tryParse(value.trim());
        if (parsed != null) {
          return parsed;
        }
      }
    }

    return 0;
  }

  static bool _readBool(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];

      if (value is bool) {
        return value;
      }

      if (value is int) {
        return value == 1;
      }

      if (value is String) {
        final normalized = value.trim().toLowerCase();

        if (normalized == '1' || normalized == 'true') {
          return true;
        }

        if (normalized == '0' || normalized == 'false') {
          return false;
        }
      }
    }

    return false;
  }
}
