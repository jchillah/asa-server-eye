// features/profile/presentation/widgets/profile_action_buttons.dart
import 'package:flutter/material.dart';

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({
    super.key,
    required this.isSaving,
    required this.isDeleting,
    required this.onSave,
    required this.onDelete,
    required this.saveLabel,
    required this.deleteLabel,
    required this.deleteHint,
  });

  final bool isSaving;
  final bool isDeleting;
  final Future<void> Function() onSave;
  final Future<void> Function() onDelete;
  final String saveLabel;
  final String deleteLabel;
  final String deleteHint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          onPressed: isSaving ? null : onSave,
          child: isSaving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(saveLabel),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: isDeleting ? null : onDelete,
          icon: const Icon(Icons.delete_outline_rounded),
          label: isDeleting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(deleteLabel),
        ),
        const SizedBox(height: 12),
        Text(deleteHint),
      ],
    );
  }
}
