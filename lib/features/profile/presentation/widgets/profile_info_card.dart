// features/profile/presentation/widgets/profile_info_card.dart
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    super.key,
    required this.emailLabel,
    required this.email,
    required this.accessLevelLabel,
    required this.accessLevel,
    required this.favoritesLabel,
    required this.favoritesCountText,
  });

  final String emailLabel;
  final String email;
  final String accessLevelLabel;
  final String accessLevel;
  final String favoritesLabel;
  final String favoritesCountText;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.mail_outline_rounded),
            title: Text(emailLabel),
            subtitle: Text(email),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.workspace_premium_outlined),
            title: Text(accessLevelLabel),
            subtitle: Text(accessLevel),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.star_outline_rounded),
            title: Text(favoritesLabel),
            subtitle: Text(favoritesCountText),
          ),
        ],
      ),
    );
  }
}
