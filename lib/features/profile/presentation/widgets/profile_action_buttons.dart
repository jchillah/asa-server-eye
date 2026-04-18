// features/profile/presentation/widgets/profile_action_buttons.dart
import 'package:asa_server_eye/core/presentation/widgets/app_action_button.dart';
import 'package:flutter/material.dart';

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({
    super.key,
    required this.isSaving,
    required this.isDeleting,
    required this.isSigningOut,
    required this.onSave,
    required this.onDelete,
    required this.onSignOut,
    required this.saveLabel,
    required this.deleteLabel,
    required this.signOutLabel,
    required this.deleteHint,
  });

  final bool isSaving;
  final bool isDeleting;
  final bool isSigningOut;
  final Future<void> Function() onSave;
  final Future<void> Function() onDelete;
  final Future<void> Function() onSignOut;
  final String saveLabel;
  final String deleteLabel;
  final String signOutLabel;
  final String deleteHint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppActionButton(
          label: saveLabel,
          isLoading: isSaving,
          onPressed: onSave,
        ),
        const SizedBox(height: 12),
        AppActionButton(
          label: signOutLabel,
          isLoading: isSigningOut,
          onPressed: onSignOut,
          variant: AppActionButtonVariant.secondary,
          icon: Icons.logout_rounded,
        ),
        const SizedBox(height: 12),
        AppActionButton(
          label: deleteLabel,
          isLoading: isDeleting,
          onPressed: onDelete,
          variant: AppActionButtonVariant.danger,
          icon: Icons.delete_outline_rounded,
        ),
        const SizedBox(height: 12),
        Text(deleteHint),
      ],
    );
  }
}
