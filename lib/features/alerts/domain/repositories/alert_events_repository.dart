// features/alerts/domain/repositories/alert_events_repository.dart
import '../entities/alert_event.dart';

abstract class AlertEventsRepository {
  Stream<List<AlertEvent>> watchEvents(String userId);

  Stream<List<AlertEvent>> watchEventsForServer({
    required String userId,
    required String serverId,
  });

  Future<void> deleteEvent({
    required String userId,
    required String eventId,
  });

  Future<void> deleteEventsForServer({
    required String userId,
    required String serverId,
  });
}
