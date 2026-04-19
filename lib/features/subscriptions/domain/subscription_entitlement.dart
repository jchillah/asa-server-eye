// features/subscriptions/domain/subscription_entitlement.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionEntitlement {
  const SubscriptionEntitlement({
    required this.userId,
    required this.productId,
    required this.purchaseStatus,
    required this.platform,
    required this.expiresAt,
    required this.updatedAt,
  });

  final String userId;
  final String? productId;
  final String purchaseStatus;
  final String? platform;
  final Timestamp? expiresAt;
  final Timestamp? updatedAt;

  bool get isActive => purchaseStatus == 'active';
  bool get isPending => purchaseStatus == 'pending';
  bool get isExpired => purchaseStatus == 'expired';

  factory SubscriptionEntitlement.fromMap(
    String userId,
    Map<String, dynamic> map,
  ) {
    return SubscriptionEntitlement(
      userId: userId,
      productId: map['productId'] as String?,
      purchaseStatus: (map['purchaseStatus'] as String?) ?? 'inactive',
      platform: map['platform'] as String?,
      expiresAt: map['expiresAt'] as Timestamp?,
      updatedAt: map['updatedAt'] as Timestamp?,
    );
  }
}
