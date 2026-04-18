// features/profile/presentation/utils/profile_message_mapper.dart
import 'package:asa_server_eye/features/profile/presentation/models/profile_delete_result.dart';
import 'package:asa_server_eye/features/profile/presentation/models/profile_save_result.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';

abstract final class ProfileMessageMapper {
  static String mapSaveResult(BuildContext context, ProfileSaveResult result) {
    switch (result) {
      case ProfileSaveResult.success:
        return context.l10n.profileSavedSuccessfully;
      case ProfileSaveResult.usernameEmpty:
        return context.l10n.usernameEmpty;
      case ProfileSaveResult.usernameTooShort:
        return context.l10n.usernameTooShort;
      case ProfileSaveResult.usernameTooLong:
        return context.l10n.usernameTooLong;
      case ProfileSaveResult.usernameInvalidCharacters:
        return context.l10n.usernameInvalidCharacters;
      case ProfileSaveResult.failure:
        return context.l10n.profileSaveError;
    }
  }

  static String mapDeleteResult(
    BuildContext context,
    ProfileDeleteResult result,
  ) {
    switch (result) {
      case ProfileDeleteResult.cancelled:
      case ProfileDeleteResult.success:
        return '';
      case ProfileDeleteResult.failure:
        return context.l10n.profileDeleteError;
    }
  }

  static String profileLoadError(BuildContext context) {
    return context.l10n.profileLoadError;
  }
}
