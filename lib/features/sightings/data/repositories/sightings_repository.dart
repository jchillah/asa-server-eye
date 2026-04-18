// features/sightings/data/repositories/sightings_repository.dart
import 'package:asa_server_eye/features/sightings/domain/gaming_platform.dart';
import 'package:asa_server_eye/features/sightings/domain/sighting_change_log.dart';
import 'package:asa_server_eye/features/sightings/domain/sighting_creator_level.dart';
import 'package:asa_server_eye/features/sightings/domain/sighting_sharing_scope.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/player_sighting.dart';
import '../models/player_sighting_model.dart';
import '../models/sighting_change_log_model.dart';

class SightingsRepository {
  SightingsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _sightingsCollection =>
      _firestore.collection('player_sightings');

  CollectionReference<Map<String, dynamic>> get _historyCollection =>
      _firestore.collection('player_sighting_history');

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
    required String inGameName,
    required String playerPlatformId,
    required String tribeName,
    required GamingPlatform platform,
    required String createdByUserId,
    required SightingCreatorLevel creatorLevel,
    required SightingSharingScope sharingScope,
    required String createdByUsername,
    required String createdByEmail,
    String? note,
  }) async {
    final sightingRef = _sightingsCollection.doc();
    final historyRef = _historyCollection.doc();
    final normalizedNote = note?.trim().isEmpty == true ? null : note?.trim();

    final sightingData = <String, dynamic>{
      'serverId': serverId,
      'inGameName': inGameName.trim(),
      'playerPlatformId': playerPlatformId.trim(),
      'tribeName': tribeName.trim(),
      'platform': platform.name,
      'createdAt': FieldValue.serverTimestamp(),
      'createdByUserId': createdByUserId,
      'createdByUsername': createdByUsername.trim(),
      'createdByEmail': createdByEmail.trim(),
      'creatorLevel': creatorLevel.name,
      'sharingScope': sharingScope.name,
      'isVisible': true,
      'note': normalizedNote,
      'updatedAt': null,
      'updatedByUserId': null,
      'deletedAt': null,
      'deletedByUserId': null,
      'deleteReason': null,
    };

    final historyData = <String, dynamic>{
      'sightingId': sightingRef.id,
      'action': SightingChangeAction.created.name,
      'changedAt': FieldValue.serverTimestamp(),
      'changedByUserId': createdByUserId,
      'summary': 'Sighting created',
      'beforeData': null,
      'afterData': {
        'serverId': serverId,
        'inGameName': inGameName.trim(),
        'playerPlatformId': playerPlatformId.trim(),
        'tribeName': tribeName.trim(),
        'platform': platform.name,
        'createdByUserId': createdByUserId,
        'createdByUsername': createdByUsername.trim(),
        'createdByEmail': createdByEmail.trim(),
        'creatorLevel': creatorLevel.name,
        'sharingScope': sharingScope.name,
        'isVisible': true,
        'note': normalizedNote,
      },
    };

    final batch = _firestore.batch();
    batch.set(sightingRef, sightingData);
    batch.set(historyRef, historyData);
    await batch.commit();
  }

  Future<void> updateSighting({
    required String sightingId,
    required String editedByUserId,
    required String inGameName,
    required String playerPlatformId,
    required String tribeName,
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
    final normalizedNote = note?.trim().isEmpty == true ? null : note?.trim();

    final updatedFields = <String, dynamic>{
      'serverId': current.serverId,
      'inGameName': inGameName.trim(),
      'playerPlatformId': playerPlatformId.trim(),
      'tribeName': tribeName.trim(),
      'platform': platform.name,
      'createdAt': Timestamp.fromDate(current.createdAt),
      'createdByUserId': current.createdByUserId,
      'createdByUsername': current.createdByUsername,
      'createdByEmail': current.createdByEmail,
      'creatorLevel': current.creatorLevel.name,
      'sharingScope': sharingScope.name,
      'isVisible': current.isVisible,
      'note': normalizedNote,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedByUserId': editedByUserId,
      'deletedAt': current.deletedAt != null
          ? Timestamp.fromDate(current.deletedAt!)
          : null,
      'deletedByUserId': current.deletedByUserId,
      'deleteReason': current.deleteReason,
    };

    final historyRef = _historyCollection.doc();
    final historyData = <String, dynamic>{
      'sightingId': current.id,
      'action': SightingChangeAction.updated.name,
      'changedAt': FieldValue.serverTimestamp(),
      'changedByUserId': editedByUserId,
      'summary': _buildUpdateSummary(
        before: current,
        after: current.copyWith(
          inGameName: inGameName.trim(),
          playerPlatformId: playerPlatformId.trim(),
          tribeName: tribeName.trim(),
          platform: platform,
          sharingScope: sharingScope,
          note: normalizedNote,
          updatedByUserId: editedByUserId,
        ),
      ),
      'beforeData': current.toFirestore(),
      'afterData': {
        'serverId': current.serverId,
        'inGameName': inGameName.trim(),
        'playerPlatformId': playerPlatformId.trim(),
        'tribeName': tribeName.trim(),
        'platform': platform.name,
        'createdByUserId': current.createdByUserId,
        'createdByUsername': current.createdByUsername,
        'createdByEmail': current.createdByEmail,
        'creatorLevel': current.creatorLevel.name,
        'sharingScope': sharingScope.name,
        'isVisible': current.isVisible,
        'note': normalizedNote,
        'updatedByUserId': editedByUserId,
      },
    };

    final batch = _firestore.batch();
    batch.update(sightingRef, updatedFields);
    batch.set(historyRef, historyData);
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
    final normalizedReason = reason.trim();

    final updatedFields = <String, dynamic>{
      'serverId': current.serverId,
      'inGameName': current.inGameName,
      'playerPlatformId': current.playerPlatformId,
      'tribeName': current.tribeName,
      'platform': current.platform.name,
      'createdAt': Timestamp.fromDate(current.createdAt),
      'createdByUserId': current.createdByUserId,
      'createdByUsername': current.createdByUsername,
      'createdByEmail': current.createdByEmail,
      'creatorLevel': current.creatorLevel.name,
      'sharingScope': current.sharingScope.name,
      'isVisible': false,
      'note': current.note,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedByUserId': deletedByUserId,
      'deletedAt': FieldValue.serverTimestamp(),
      'deletedByUserId': deletedByUserId,
      'deleteReason': normalizedReason,
    };

    final historyRef = _historyCollection.doc();
    final historyData = <String, dynamic>{
      'sightingId': current.id,
      'action': SightingChangeAction.softDeleted.name,
      'changedAt': FieldValue.serverTimestamp(),
      'changedByUserId': deletedByUserId,
      'summary': 'Sighting soft deleted. Reason: $normalizedReason',
      'beforeData': current.toFirestore(),
      'afterData': {
        'serverId': current.serverId,
        'inGameName': current.inGameName,
        'playerPlatformId': current.playerPlatformId,
        'tribeName': current.tribeName,
        'platform': current.platform.name,
        'createdByUserId': current.createdByUserId,
        'createdByUsername': current.createdByUsername,
        'createdByEmail': current.createdByEmail,
        'creatorLevel': current.creatorLevel.name,
        'sharingScope': current.sharingScope.name,
        'isVisible': false,
        'note': current.note,
        'updatedByUserId': deletedByUserId,
        'deletedByUserId': deletedByUserId,
        'deleteReason': normalizedReason,
      },
    };

    final batch = _firestore.batch();
    batch.update(sightingRef, updatedFields);
    batch.set(historyRef, historyData);
    await batch.commit();
  }

  Future<List<PlayerSighting>> fetchOwnSightingsByServerId({
    required String serverId,
    required String userId,
  }) async {
    final snapshot = await _sightingsCollection
        .where('serverId', isEqualTo: serverId)
        .where('createdByUserId', isEqualTo: userId)
        .where('isVisible', isEqualTo: true)
        .get();

    return snapshot.docs
        .map(PlayerSightingModel.fromFirestore)
        .toList(growable: false);
  }

  Future<List<PlayerSighting>> fetchPremiumSharedSightingsByServerId(
    String serverId,
  ) async {
    final snapshot = await _sightingsCollection
        .where('serverId', isEqualTo: serverId)
        .where('isVisible', isEqualTo: true)
        .where('sharingScope', isEqualTo: 'premiumShared')
        .get();

    return snapshot.docs
        .map(PlayerSightingModel.fromFirestore)
        .toList(growable: false);
  }

  Future<List<PlayerSighting>> fetchAllSightingsByServerId(
    String serverId,
  ) async {
    final snapshot = await _sightingsCollection
        .where('serverId', isEqualTo: serverId)
        .get();

    return snapshot.docs
        .map(PlayerSightingModel.fromFirestore)
        .toList(growable: false);
  }

  Future<void> hardDeleteSighting({required String sightingId}) async {
    final sightingRef = _sightingsCollection.doc(sightingId);

    final historySnapshot = await _historyCollection
        .where('sightingId', isEqualTo: sightingId)
        .get();

    final batch = _firestore.batch();

    for (final doc in historySnapshot.docs) {
      batch.delete(doc.reference);
    }

    batch.delete(sightingRef);

    await batch.commit();
  }

  String _buildUpdateSummary({
    required PlayerSightingModel before,
    required PlayerSightingModel after,
  }) {
    final changes = <String>[];

    if (before.inGameName != after.inGameName) {
      changes.add('inGameName');
    }

    if (before.playerPlatformId != after.playerPlatformId) {
      changes.add('playerPlatformId');
    }

    if (before.tribeName != after.tribeName) {
      changes.add('tribeName');
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
