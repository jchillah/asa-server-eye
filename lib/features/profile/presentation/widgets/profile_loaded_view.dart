// features/profile/presentation/widgets/profile_loaded_view.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:asa_server_eye/core/presentation/widgets/app_action_button.dart';
import 'package:asa_server_eye/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:asa_server_eye/features/subscriptions/presentation/utils/premium_navigation.dart';
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

  bool get _isPremiumOrAdmin =>
      profile.sightingsAccessLevel == 'premium' ||
      profile.sightingsAccessLevel == 'admin';

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
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isPremiumOrAdmin
                      ? context.l10n.premiumActiveTitle
                      : context.l10n.premiumUpgradeTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  _isPremiumOrAdmin
                      ? context.l10n.premiumActiveDescription
                      : context.l10n.premiumUpgradeDescription,
                ),
                const SizedBox(height: 12),
                AppActionButton(
                  label: _isPremiumOrAdmin
                      ? context.l10n.managePremium
                      : context.l10n.unlockPremium,
                  isLoading: false,
                  variant: _isPremiumOrAdmin
                      ? AppActionButtonVariant.secondary
                      : AppActionButtonVariant.primary,
                  onPressed: () async {
                    await PremiumNavigation.open(context);
                  },
                ),
              ],
            ),
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
