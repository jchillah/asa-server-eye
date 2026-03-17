// features/settings/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../../../core/presentation/l10n/app_language.dart';
import '../../../../core/presentation/l10n/locale_controller.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/language_dialog.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_tile.dart';
import 'about_screen.dart';
import 'imprint_screen.dart';
import 'privacy_screen.dart';
import 'support_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    final option = optionFromLocale(locale);

    final languageSubtitle = switch (option) {
      AppLanguageOption.german => context.l10n.german,
      AppLanguageOption.english => context.l10n.english,
      AppLanguageOption.spanish => context.l10n.spanish,
      AppLanguageOption.french => context.l10n.french,
      AppLanguageOption.chinese => context.l10n.chinese,
      AppLanguageOption.system => context.l10n.systemLanguage,
    };

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: ListView(
        children: [
          SettingsSectionHeader(title: context.l10n.general),
          SettingsTile(
            icon: Icons.language,
            title: context.l10n.language,
            subtitle: languageSubtitle,
            onTap: () => showLanguageDialog(context, ref),
          ),
          SettingsTile(
            icon: Icons.info_outline,
            title: context.l10n.about,
            subtitle: context.l10n.appInformation,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AboutScreen()));
            },
          ),
          SettingsSectionHeader(title: context.l10n.legal),
          SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: context.l10n.privacyPolicy,
            subtitle: context.l10n.howDataIsHandled,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const PrivacyScreen()));
            },
          ),
          SettingsTile(
            icon: Icons.gavel_outlined,
            title: context.l10n.imprint,
            subtitle: context.l10n.legalInformation,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ImprintScreen()));
            },
          ),
          SettingsTile(
            icon: Icons.support_agent,
            title: context.l10n.support,
            subtitle: context.l10n.getHelpAndContactSupport,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SupportScreen()));
            },
          ),
          SettingsSectionHeader(title: context.l10n.account),
          SettingsTile(
            icon: Icons.logout,
            title: context.l10n.signOut,
            subtitle: context.l10n.signOutDescription,
            onTap: () async {
              await ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
    );
  }
}
