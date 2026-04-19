// features/subscriptions/presentation/providers/subscription_providers.dart
import 'package:asa_server_eye/features/subscriptions/data/repositories/subscription_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

final inAppPurchaseProvider = Provider<InAppPurchase>((ref) {
  return InAppPurchase.instance;
});

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final inAppPurchase = ref.watch(inAppPurchaseProvider);
  return SubscriptionRepository(inAppPurchase);
});
