// features/subscriptions/data/repositories/subscription_verification_request_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionVerificationRequestRepository {
  SubscriptionVerificationRequestRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('subscription_verification_requests');

  Future<void> submitVerificationRequest({
    required String userId,
    required String platform,
    required String productId,
    required String purchaseId,
    required String purchaseToken,
  }) async {
    await _collection.add({
      'userId': userId,
      'platform': platform,
      'productId': productId,
      'purchaseId': purchaseId,
      'purchaseToken': purchaseToken,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
