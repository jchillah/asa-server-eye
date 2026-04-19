// features/subscriptions/data/repositories/subscription_entitlement_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/subscription_entitlement.dart';

class SubscriptionEntitlementRepository {
  SubscriptionEntitlementRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _subscriptionDoc(String userId) {
    return _firestore.collection('user_subscriptions').doc(userId);
  }

  Stream<SubscriptionEntitlement?> watchEntitlement(String userId) {
    return _subscriptionDoc(userId).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) {
        return null;
      }

      return SubscriptionEntitlement.fromMap(doc.id, data);
    });
  }
}
