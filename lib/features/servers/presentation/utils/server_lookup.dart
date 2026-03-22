// features/servers/presentation/utils/server_lookup.dart
import '../../domain/server.dart';

abstract final class ServerLookup {
  static Server? byId(List<Server> servers, String serverId) {
    for (final server in servers) {
      if (server.id == serverId) {
        return server;
      }
    }
    return null;
  }
}
