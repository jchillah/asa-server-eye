// features/profile/presentation/widgets/profile_loaded_view.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:asa_server_eye/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/app_user_profile.dart';
import '../providers/profile_form_controller_provider.dart';
import '../utils/profile_screen_actions.dart';
import 'profile_action_buttons.dart';
import 'profile_avatar_section.dart';
import 'profile_info_card.dart';

class ProfileLoadedView extends ConsumerWidget {
  const ProfileLoadedView({
    super.key,
    required this.profile,
    required this.avatarImage,
    required this.isSaving,
    required this.isDeleting,
    required this.usernameController,
  });

  final AppUserProfile profile;
  final ImageProvider<Object>? avatarImage;
  final bool isSaving;
  final bool isDeleting;
  final TextEditingController usernameController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProfileAvatarSection(
          avatarImage: avatarImage,
          isSaving: isSaving,
          onEditTap: () => ref.read(profileFormControllerProvider).pickImage(),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            labelText: context.l10n.username,
            prefixIcon: const Icon(Icons.person_outline_rounded),
          ),
        ),
        const SizedBox(height: 16),
        ProfileInfoCard(
          emailLabel: context.l10n.email,
          email: profile.email,
          accessLevelLabel: context.l10n.accessLevel,
          accessLevel: profile.sightingsAccessLevel,
          favoritesLabel: context.l10n.favorites,
          favoritesCountText: context.l10n.savedFavoritesCount(
            profile.favoriteIds.length,
          ),
        ),
        const SizedBox(height: 24),
        ProfileActionButtons(
          isSaving: isSaving,
          isDeleting: isDeleting,
          isSigningOut: false,
          saveLabel: context.l10n.save,
          signOutLabel: context.l10n.signOut,
          deleteLabel: context.l10n.deleteAccount,
          deleteHint: context.l10n.deleteAccountHint,
          onSave: () => ProfileScreenActions.save(context: context, ref: ref),
          onSignOut: () async {
            await ref.read(authRepositoryProvider).signOut();
          },
          onDelete: () =>
              ProfileScreenActions.delete(context: context, ref: ref),
        ),
      ],
    );
  }
}
