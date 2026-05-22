// features/alerts/data/repositories/firestore_alert_rules_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/alert_rule.dart';
import '../../domain/repositories/alert_rules_repository.dart';
import '../dtos/alert_rule_dto.dart';

class FirestoreAlertRulesRepository implements AlertRulesRepository {
  FirestoreAlertRulesRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _rulesCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('alert_rules');
  }

  @override
  Stream<List<AlertRule>> watchRules(String userId) {
    return _rulesCollection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    AlertRuleDto.fromFirestore(doc.data()).toDomain(doc.id),
              )
              .toList(),
        );
  }

  @override
  Stream<List<AlertRule>> watchRulesForServer({
    required String userId,
    required String serverId,
  }) {
    return _rulesCollection(userId)
        .where('serverId', isEqualTo: serverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    AlertRuleDto.fromFirestore(doc.data()).toDomain(doc.id),
              )
              .toList(),
        );
  }

  @override
  Future<void> createRule(AlertRule rule) async {
    final docRef = _rulesCollection(rule.userId).doc();
    final dto = AlertRuleDto.fromDomain(
      rule.copyWith(id: docRef.id, createdAt: null, updatedAt: null),
    );

    await docRef.set({
      ...dto.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateRule(AlertRule rule) async {
    final dto = AlertRuleDto.fromDomain(rule);

    await _rulesCollection(rule.userId).doc(rule.id).update({
      ...dto.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteRule({
    required String userId,
    required String ruleId,
  }) async {
    await _rulesCollection(userId).doc(ruleId).delete();
  }

  @override
  Future<void> setRuleEnabled({
    required String userId,
    required String ruleId,
    required bool isEnabled,
  }) async {
    await _rulesCollection(userId).doc(ruleId).update({
      'isEnabled': isEnabled,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
