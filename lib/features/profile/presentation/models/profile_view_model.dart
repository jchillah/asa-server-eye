// features/profile/presentation/models/profile_view_model.dart
import 'package:flutter/material.dart';

import '../../domain/app_user_profile.dart';

class ProfileViewModel {
  const ProfileViewModel({
    required this.profile,
    required this.isLoading,
    required this.hasError,
    required this.isSaving,
    required this.isDeleting,
    required this.usernameController,
    required this.avatarImage,
  });

  final AppUserProfile? profile;
  final bool isLoading;
  final bool hasError;
  final bool isSaving;
  final bool isDeleting;
  final TextEditingController usernameController;
  final ImageProvider<Object>? avatarImage;

  bool get hasProfile => profile != null;
}
