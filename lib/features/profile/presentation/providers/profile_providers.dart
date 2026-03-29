// features/profile/presentation/providers/profile_providers.dart
import 'package:asa_server_eye/features/profile/presentation/providers/profile_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/app_user_profile.dart';

final profileProvider = StreamProvider<AppUserProfile?>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.watchProfile();
});
