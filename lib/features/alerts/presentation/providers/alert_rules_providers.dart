// features/alerts/presentation/providers/alert_rules_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../data/repositories/firestore_alert_rules_repository.dart';
import '../../domain/entities/alert_rule.dart';
import '../../domain/repositories/alert_rules_repository.dart';

final alertRulesRepositoryProvider = Provider<AlertRulesRepository>((ref) {
  return FirestoreAlertRulesRepository(FirebaseFirestore.instance);
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  return authState?.uid;
});

final userAlertRulesProvider = StreamProvider.autoDispose<List<AlertRule>>((
  ref,
) {
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    return const Stream.empty();
  }

  return ref.watch(alertRulesRepositoryProvider).watchRules(userId);
});

final serverAlertRulesProvider = StreamProvider.autoDispose
    .family<List<AlertRule>, String>((ref, serverId) {
      final userId = ref.watch(currentUserIdProvider);

      if (userId == null) {
        return const Stream.empty();
      }

      return ref
          .watch(alertRulesRepositoryProvider)
          .watchRulesForServer(userId: userId, serverId: serverId);
    });
