// features/profile/presentation/providers/profile_view_model_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/app_user_profile.dart';
import '../models/profile_view_model.dart';
import 'profile_form_controller_provider.dart';
import 'profile_providers.dart';

final profileViewModelProvider = Provider<ProfileViewModel>((ref) {
  final profileAsync = ref.watch(profileProvider);
  final formController = ref.watch(profileFormControllerProvider);

  final profile = profileAsync.valueOrNull;

  if (profile != null) {
    ref.read(profileFormControllerProvider).hydrate(profile);
  }

  return ProfileViewModel(
    profile: profile,
    isLoading: profileAsync.isLoading,
    hasError: profileAsync.hasError,
    isSaving: formController.isSaving,
    isDeleting: formController.isDeleting,
    usernameController: formController.usernameController,
    avatarImage: formController.resolveAvatarImage(profile?.photoUrl),
  );
});

final profileViewProfileProvider = Provider<AppUserProfile?>((ref) {
  return ref.watch(profileViewModelProvider).profile;
});
