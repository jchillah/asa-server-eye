// features/subscriptions/data/subscription_product_ids.dart
abstract final class SubscriptionProductIds {
  static const String premiumMonthly = 'asa_premium_monthly';
  static const String premiumYearly = 'asa_premium_yearly';

  static const Set<String> all = {premiumMonthly, premiumYearly};
}
