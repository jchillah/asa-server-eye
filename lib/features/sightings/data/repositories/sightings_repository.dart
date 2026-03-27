// features/sightings/data/repositories/sightings_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/player_sighting.dart';
import '../../domain/sighting_change_log.dart';
import '../models/player_sighting_model.dart';
import '../models/sighting_change_log_model.dart';

class SightingsRepository {
  SightingsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _sightingsCollection =>
      _firestore.collection('player_sightings');

  CollectionReference<Map<String, dynamic>> get _historyCollection =>
      _firestore.collection('player_sighting_history');

  Future<List<PlayerSighting>> fetchSightingsByServerId(String serverId) async {
    final snapshot = await _sightingsCollection
        .where('serverId', isEqualTo: serverId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map(PlayerSightingModel.fromFirestore)
        .toList(growable: false);
  }

  Future<List<SightingChangeLog>> fetchHistoryBySightingId(
    String sightingId,
  ) async {
    final snapshot = await _historyCollection
        .where('sightingId', isEqualTo: sightingId)
        .orderBy('changedAt', descending: true)
        .get();

    return snapshot.docs
        .map(SightingChangeLogModel.fromFirestore)
        .toList(growable: false);
  }

  Future<void> createSighting({
    required String serverId,
    required String playerName,
    required String playerId,
    required GamingPlatform platform,
    required String createdByUserId,
    required SightingVisibilityLevel visibilityLevel,
    required SightingSharingScope sharingScope,
    String? note,
  }) async {
    final sightingRef = _sightingsCollection.doc();
    final historyRef = _historyCollection.doc();
    final now = DateTime.now();

    final sighting = PlayerSightingModel(
      id: sightingRef.id,
      serverId: serverId,
      playerName: playerName.trim(),
      playerId: playerId.trim(),
      platform: platform,
      createdAt: now,
      createdByUserId: createdByUserId,
      visibilityLevel: visibilityLevel,
      sharingScope: sharingScope,
      isVisible: true,
      note: note?.trim().isEmpty == true ? null : note?.trim(),
      updatedAt: null,
      deletedAt: null,
      deletedByUserId: null,
      deleteReason: null,
    );

    final history = SightingChangeLogModel(
      id: historyRef.id,
      sightingId: sightingRef.id,
      action: SightingChangeAction.created,
      changedAt: now,
      changedByUserId: createdByUserId,
      summary: 'Sighting created',
      beforeData: null,
      afterData: sighting.toFirestore(),
    );

    final batch = _firestore.batch();
    batch.set(sightingRef, sighting.toFirestore());
    batch.set(historyRef, history.toFirestore());
    await batch.commit();
  }

  Future<void> updateSighting({
    required String sightingId,
    required String editedByUserId,
    required String playerName,
    required String playerId,
    required GamingPlatform platform,
    required SightingSharingScope sharingScope,
    String? note,
  }) async {
    final sightingRef = _sightingsCollection.doc(sightingId);
    final currentDoc = await sightingRef.get();

    if (!currentDoc.exists) {
      throw StateError('Sighting not found');
    }

    final current = PlayerSightingModel.fromFirestore(currentDoc);
    final now = DateTime.now();

    final updated = current.copyWith(
      playerName: playerName.trim(),
      playerId: playerId.trim(),
      platform: platform,
      sharingScope: sharingScope,
      note: note?.trim().isEmpty == true ? null : note?.trim(),
      updatedAt: now,
    );

    final historyRef = _historyCollection.doc();
    final history = SightingChangeLogModel(
      id: historyRef.id,
      sightingId: current.id,
      action: SightingChangeAction.updated,
      changedAt: now,
      changedByUserId: editedByUserId,
      summary: _buildUpdateSummary(before: current, after: updated),
      beforeData: current.toFirestore(),
      afterData: updated.toFirestore(),
    );

    final batch = _firestore.batch();
    batch.update(sightingRef, updated.toFirestore());
    batch.set(historyRef, history.toFirestore());
    await batch.commit();
  }

  Future<void> softDeleteSighting({
    required String sightingId,
    required String deletedByUserId,
    required String reason,
  }) async {
    final sightingRef = _sightingsCollection.doc(sightingId);
    final currentDoc = await sightingRef.get();

    if (!currentDoc.exists) {
      throw StateError('Sighting not found');
    }

    final current = PlayerSightingModel.fromFirestore(currentDoc);
    final now = DateTime.now();

    final updated = current.copyWith(
      isVisible: false,
      deletedAt: now,
      deletedByUserId: deletedByUserId,
      deleteReason: reason.trim(),
      updatedAt: now,
    );

    final historyRef = _historyCollection.doc();
    final history = SightingChangeLogModel(
      id: historyRef.id,
      sightingId: current.id,
      action: SightingChangeAction.softDeleted,
      changedAt: now,
      changedByUserId: deletedByUserId,
      summary: 'Sighting soft deleted. Reason: ${reason.trim()}',
      beforeData: current.toFirestore(),
      afterData: updated.toFirestore(),
    );

    final batch = _firestore.batch();
    batch.update(sightingRef, updated.toFirestore());
    batch.set(historyRef, history.toFirestore());
    await batch.commit();
  }

  String _buildUpdateSummary({
    required PlayerSightingModel before,
    required PlayerSightingModel after,
  }) {
    final changes = <String>[];

    if (before.playerName != after.playerName) {
      changes.add('playerName');
    }

    if (before.playerId != after.playerId) {
      changes.add('playerId');
    }

    if (before.platform != after.platform) {
      changes.add('platform');
    }

    if (before.note != after.note) {
      changes.add('note');
    }

    if (before.sharingScope != after.sharingScope) {
      changes.add('sharingScope');
    }

    if (changes.isEmpty) {
      return 'Sighting updated';
    }

    return 'Updated: ${changes.join(', ')}';
  }
}
