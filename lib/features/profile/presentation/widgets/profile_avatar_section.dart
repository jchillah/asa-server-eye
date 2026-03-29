// features/profile/presentation/widgets/profile_avatar_section.dart
import 'package:flutter/material.dart';

class ProfileAvatarSection extends StatelessWidget {
  const ProfileAvatarSection({
    super.key,
    required this.avatarImage,
    required this.isSaving,
    required this.onEditTap,
  });

  final ImageProvider<Object>? avatarImage;
  final bool isSaving;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundImage: avatarImage,
            child: avatarImage == null
                ? const Icon(Icons.person, size: 42)
                : null,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton.filled(
              onPressed: isSaving ? null : onEditTap,
              icon: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}
