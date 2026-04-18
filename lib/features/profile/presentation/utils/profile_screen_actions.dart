// features/profile/presentation/utils/profile_screen_actions.dart
import 'package:asa_server_eye/features/profile/presentation/models/profile_delete_result.dart';
import 'package:asa_server_eye/features/profile/presentation/providers/profile_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_form_controller_provider.dart';
import '../utils/profile_dialogs.dart';
import '../utils/profile_feedback.dart';
import '../utils/profile_message_mapper.dart';

abstract final class ProfileScreenActions {
  static Future<void> save({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final controller = ref.read(profileFormControllerProvider);
    final profile = ref.read(profileViewProfileProvider);

    if (profile == null) {
      ProfileFeedback.showMessage(
        context,
        ProfileMessageMapper.profileLoadError(context),
      );
      return;
    }

    final result = await controller.saveProfile(currentProfile: profile);

    if (!context.mounted) return;

    ProfileFeedback.showMessage(
      context,
      ProfileMessageMapper.mapSaveResult(context, result),
    );
  }

  static Future<void> delete({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final profile = ref.read(profileViewProfileProvider);

    if (profile == null) {
      ProfileFeedback.showMessage(
        context,
        ProfileMessageMapper.profileLoadError(context),
      );
      return;
    }

    final password = await ProfileDialogs.showDeleteAccountDialog(
      context: context,
      email: profile.email,
    );

    if (password == null || password.isEmpty) {
      return;
    }

    final result = await ref
        .read(profileFormControllerProvider)
        .deleteAccount(email: profile.email, password: password);

    if (!context.mounted) return;

    if (result == ProfileDeleteResult.failure) {
      ProfileFeedback.showMessage(
        context,
        ProfileMessageMapper.mapDeleteResult(context, result),
      );
    }
  }
}
