// features/subscriptions/presentation/providers/subscription_entitlement_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/current_user_provider.dart';
import '../../../auth/presentation/providers/firestore_provider.dart';
import '../../data/repositories/subscription_entitlement_repository.dart';
import '../../data/repositories/subscription_verification_request_repository.dart';
import '../../domain/subscription_entitlement.dart';

final subscriptionEntitlementRepositoryProvider =
    Provider<SubscriptionEntitlementRepository>((ref) {
      final firestore = ref.watch(firestoreProvider);
      return SubscriptionEntitlementRepository(firestore);
    });

final subscriptionVerificationRequestRepositoryProvider =
    Provider<SubscriptionVerificationRequestRepository>((ref) {
      final firestore = ref.watch(firestoreProvider);
      return SubscriptionVerificationRequestRepository(firestore);
    });

final currentSubscriptionEntitlementProvider =
    StreamProvider.autoDispose<SubscriptionEntitlement?>((ref) {
      final currentUser = ref.watch(currentUserProvider);

      if (currentUser == null) {
        return Stream.value(null);
      }

      final repository = ref.watch(subscriptionEntitlementRepositoryProvider);
      return repository.watchEntitlement(currentUser.uid);
    });
