// features/alerts/data/repositories/firestore_alert_events_repository.dart
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/alert_event.dart';
import '../../domain/repositories/alert_events_repository.dart';
import '../dtos/alert_event_dto.dart';

class FirestoreAlertEventsRepository implements AlertEventsRepository {
  FirestoreAlertEventsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _eventsCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('alert_events');
  }

  List<AlertEvent> _mapEvents(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final events = <AlertEvent>[];

    for (final doc in snapshot.docs) {
      try {
        final event = AlertEventDto.fromFirestore(doc.data()).toDomain(doc.id);
        events.add(event);
      } catch (error, stackTrace) {
        developer.log(
          'Skipping invalid alert event document: ${doc.id}',
          name: 'FirestoreAlertEventsRepository',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }

    events.sort(_compareByNewest);
    return events;
  }

  int _compareByNewest(AlertEvent first, AlertEvent second) {
    final firstDate = first.triggeredAt ?? first.createdAt;
    final secondDate = second.triggeredAt ?? second.createdAt;

    if (firstDate == null && secondDate == null) {
      return second.id.compareTo(first.id);
    }

    if (firstDate == null) {
      return 1;
    }

    if (secondDate == null) {
      return -1;
    }

    return secondDate.compareTo(firstDate);
  }

  @override
  Stream<List<AlertEvent>> watchEvents(String userId) {
    return _eventsCollection(
      userId,
    ).orderBy('triggeredAt', descending: true).limit(100).snapshots().map(
      _mapEvents,
    );
  }

  @override
  Stream<List<AlertEvent>> watchEventsForServer({
    required String userId,
    required String serverId,
  }) {
    return _eventsCollection(userId)
        .where('serverId', isEqualTo: serverId)
        .orderBy('triggeredAt', descending: true)
        .limit(100)
        .snapshots()
        .map(_mapEvents);
  }

  @override
  Future<void> deleteEvent({
    required String userId,
    required String eventId,
  }) async {
    await _eventsCollection(userId).doc(eventId).delete();
  }

  @override
  Future<void> deleteEventsForServer({
    required String userId,
    required String serverId,
  }) async {
    final snapshot = await _eventsCollection(
      userId,
    ).where('serverId', isEqualTo: serverId).get();

    if (snapshot.docs.isEmpty) {
      return;
    }

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
