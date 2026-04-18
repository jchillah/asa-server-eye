// features/settings/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../../../core/presentation/l10n/app_language.dart';
import '../../../../core/presentation/l10n/locale_controller.dart';
import '../../../profile/presentation/utils/profile_navigation.dart';
import '../utils/settings_navigation.dart';
import '../widgets/language_dialog.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_tile.dart';

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
      appBar: AppBar(
        title: Text(context.l10n.settings),
        actions: [
          IconButton(
            onPressed: () => ProfileNavigation.openProfile(context),
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Profil',
          ),
        ],
      ),
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
            onTap: () => SettingsNavigation.openAbout(context),
          ),
          SettingsSectionHeader(title: context.l10n.legal),
          SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: context.l10n.privacyPolicy,
            subtitle: context.l10n.howDataIsHandled,
            onTap: () => SettingsNavigation.openPrivacy(context),
          ),
          SettingsTile(
            icon: Icons.gavel_outlined,
            title: context.l10n.imprint,
            subtitle: context.l10n.legalInformation,
            onTap: () => SettingsNavigation.openImprint(context),
          ),
          SettingsTile(
            icon: Icons.support_agent,
            title: context.l10n.support,
            subtitle: context.l10n.getHelpAndContactSupport,
            onTap: () => SettingsNavigation.openSupport(context),
          ),
        ],
      ),
    );
  }
}
