// features/subscriptions/domain/store_subscription_product.dart
import 'package:in_app_purchase/in_app_purchase.dart';

import 'subscription_plan.dart';

class StoreSubscriptionProduct {
  const StoreSubscriptionProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.plan,
    required this.raw,
  });

  final String id;
  final String title;
  final String description;
  final String price;
  final SubscriptionPlan plan;
  final ProductDetails raw;
}
