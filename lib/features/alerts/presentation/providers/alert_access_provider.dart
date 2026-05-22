// features/alerts/presentation/providers/alert_access_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../subscriptions/presentation/providers/subscription_entitlement_providers.dart';

class AlertAccessState {
  const AlertAccessState({
    required this.isResolved,
    required this.canManageAlerts,
  });

  final bool isResolved;
  final bool canManageAlerts;

  bool get shouldShowPremiumUpsell => isResolved && !canManageAlerts;
}

final alertAccessProvider = Provider.autoDispose<AlertAccessState>((ref) {
  final profileAsync = ref.watch(profileProvider);
  final entitlementAsync = ref.watch(currentSubscriptionEntitlementProvider);

  final profileAccessLevel =
      profileAsync.valueOrNull?.sightingsAccessLevel ?? 'free';

  final hasProfileAlertAccess = _alertEnabledProfileLevels.contains(
    profileAccessLevel,
  );

  final hasActiveSubscription =
      entitlementAsync.valueOrNull?.isActive ?? false;

  return AlertAccessState(
    isResolved: profileAsync.hasValue && entitlementAsync.hasValue,
    canManageAlerts: hasProfileAlertAccess || hasActiveSubscription,
  );
});

const _alertEnabledProfileLevels = {
  'premium',
  'admin',
};
