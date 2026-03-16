// features/settings/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../../../core/presentation/l10n/locale_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    final languageSubtitle = switch (locale?.languageCode) {
      'de' => context.l10n.german,
      'en' => context.l10n.english,
      _ => context.l10n.systemLanguage,
    };

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: ListView(
        children: [
          _SettingsSectionHeader(title: context.l10n.general),
          _SettingsTile(
            icon: Icons.language,
            title: context.l10n.language,
            subtitle: languageSubtitle,
            onTap: () => _showLanguageDialog(context, ref),
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: context.l10n.about,
            subtitle: context.l10n.appInformation,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.comingSoon(context.l10n.about)),
                ),
              );
            },
          ),
          _SettingsSectionHeader(title: context.l10n.legal),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: context.l10n.privacyPolicy,
            subtitle: context.l10n.howDataIsHandled,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.l10n.comingSoon(context.l10n.privacyPolicy),
                  ),
                ),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.gavel_outlined,
            title: context.l10n.imprint,
            subtitle: context.l10n.legalInformation,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.comingSoon(context.l10n.imprint)),
                ),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.support_agent,
            title: context.l10n.support,
            subtitle: context.l10n.getHelpAndContactSupport,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.comingSoon(context.l10n.support)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguageDialog(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(localeControllerProvider.notifier);
    final currentLocale = ref.read(localeControllerProvider);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final currentCode = currentLocale?.languageCode;

        return AlertDialog(
          title: Text(context.l10n.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String?>(
                value: null,
                groupValue: currentCode,
                title: Text(context.l10n.systemLanguage),
                onChanged: (_) {
                  controller.useSystemLocale();
                  Navigator.of(dialogContext).pop();
                },
              ),
              RadioListTile<String?>(
                value: 'de',
                groupValue: currentCode,
                title: Text(context.l10n.german),
                onChanged: (_) {
                  controller.setGerman();
                  Navigator.of(dialogContext).pop();
                },
              ),
              RadioListTile<String?>(
                value: 'en',
                groupValue: currentCode,
                title: Text(context.l10n.english),
                onChanged: (_) {
                  controller.setEnglish();
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  const _SettingsSectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
