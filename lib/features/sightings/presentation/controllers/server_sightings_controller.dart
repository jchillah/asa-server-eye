// features/sightings/presentation/controllers/server_sightings_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/player_sighting.dart';
import '../providers/sightings_providers.dart';

final serverSightingsControllerProvider = Provider.autoDispose
    .family<AsyncValue<List<PlayerSighting>>, String>((ref, serverId) {
      return ref.watch(serverSightingsProvider(serverId));
    });
