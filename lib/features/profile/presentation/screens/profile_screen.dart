// features/profile/presentation/screens/profile_screen.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_view_model_provider.dart';
import '../widgets/profile_loaded_view.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profile)),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.hasError || !viewModel.hasProfile) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(context.l10n.profileLoadError),
              ),
            );
          }

          return ProfileLoadedView(
            profile: viewModel.profile!,
            avatarImage: viewModel.avatarImage,
            isSaving: viewModel.isSaving,
            isDeleting: viewModel.isDeleting,
            usernameController: viewModel.usernameController,
          );
        },
      ),
    );
  }
}
