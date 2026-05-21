// features/servers/presentation/state/server_sync_error.dart

class ServerSyncError {
  const ServerSyncError({
    required this.error,
    required this.stackTrace,
    required this.occurredAt,
  });

  final Object error;
  final StackTrace stackTrace;
  final DateTime occurredAt;

  @override
  String toString() {
    return 'ServerSyncError(error: $error, occurredAt: $occurredAt)';
  }
}
