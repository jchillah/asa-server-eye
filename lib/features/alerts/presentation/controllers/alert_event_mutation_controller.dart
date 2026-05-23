// features/alerts/presentation/controllers/alert_event_mutation_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/alert_events_providers.dart';

final alertEventMutationControllerProvider =
    AutoDisposeAsyncNotifierProvider<AlertEventMutationController, void>(
      AlertEventMutationController.new,
    );

class AlertEventMutationController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> deleteEvent({
    required String userId,
    required String eventId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref
          .read(alertEventsRepositoryProvider)
          .deleteEvent(userId: userId, eventId: eventId);
    });
  }

  Future<void> deleteEventsForServer({
    required String userId,
    required String serverId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref
          .read(alertEventsRepositoryProvider)
          .deleteEventsForServer(userId: userId, serverId: serverId);
    });
  }
}
