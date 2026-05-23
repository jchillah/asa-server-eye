// features/alerts/presentation/providers/alert_events_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/firestore_alert_events_repository.dart';
import '../../domain/entities/alert_event.dart';
import '../../domain/repositories/alert_events_repository.dart';
import 'alert_rules_providers.dart';

final alertEventsRepositoryProvider = Provider<AlertEventsRepository>((ref) {
  return FirestoreAlertEventsRepository(FirebaseFirestore.instance);
});

final userAlertEventsProvider = StreamProvider.autoDispose<List<AlertEvent>>((
  ref,
) {
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    return const Stream.empty();
  }

  return ref.watch(alertEventsRepositoryProvider).watchEvents(userId);
});

final serverAlertEventsProvider = StreamProvider.autoDispose
    .family<List<AlertEvent>, String>((ref, serverId) {
      final userId = ref.watch(currentUserIdProvider);

      if (userId == null) {
        return const Stream.empty();
      }

      return ref.watch(alertEventsRepositoryProvider).watchEventsForServer(
        userId: userId,
        serverId: serverId,
      );
    });
