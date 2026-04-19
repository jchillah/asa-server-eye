// features/subscriptions/data/repositories/subscription_repository.dart
import 'dart:async';

import 'package:asa_server_eye/features/subscriptions/data/subscription_product_ids.dart';
import 'package:asa_server_eye/features/subscriptions/domain/store_subscription_product.dart';
import 'package:asa_server_eye/features/subscriptions/domain/subscription_plan.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._inAppPurchase);

  final InAppPurchase _inAppPurchase;

  Stream<List<PurchaseDetails>> get purchaseStream =>
      _inAppPurchase.purchaseStream;

  Future<bool> isAvailable() {
    return _inAppPurchase.isAvailable();
  }

  Future<List<StoreSubscriptionProduct>> loadProducts() async {
    final response = await _inAppPurchase.queryProductDetails(
      SubscriptionProductIds.all,
    );

    if (response.error != null) {
      throw StateError(response.error!.message);
    }

    final products = response.productDetails
        .map(_mapProduct)
        .whereType<StoreSubscriptionProduct>()
        .toList(growable: false);

    products.sort((a, b) => a.plan.index.compareTo(b.plan.index));

    return products;
  }

  Future<void> buy(StoreSubscriptionProduct product) async {
    final purchaseParam = PurchaseParam(productDetails: product.raw);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() {
    return _inAppPurchase.restorePurchases();
  }

  Future<void> completePurchase(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchase);
    }
  }

  StoreSubscriptionProduct? _mapProduct(ProductDetails product) {
    final plan = switch (product.id) {
      SubscriptionProductIds.premiumMonthly => SubscriptionPlan.monthly,
      SubscriptionProductIds.premiumYearly => SubscriptionPlan.yearly,
      _ => null,
    };

    if (plan == null) {
      return null;
    }

    return StoreSubscriptionProduct(
      id: product.id,
      title: product.title,
      description: product.description,
      price: product.price,
      plan: plan,
      raw: product,
    );
  }
}
