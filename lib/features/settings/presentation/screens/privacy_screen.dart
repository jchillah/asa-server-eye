// features/settings/presentation/screens/privacy_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/ads/ads_consent_service.dart';
import '../../../../core/extensions/context_l10n.dart';
import '../utils/support_actions.dart';
import '../widgets/simple_info_screen.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final consentService = AdsConsentService.instance;

    return SimpleInfoScreen(
      title: context.l10n.privacyPolicy,
      body: context.l10n.privacyBody,
      bottom: Column(
        children: [
          const SizedBox(height: 24),
          FilledButton(
            onPressed: SupportActions.openPrivacyPolicy,
            child: Text(context.l10n.fullPrivacyPolicy),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: SupportActions.openDeleteAccount,
            child: Text(context.l10n.deleteAccount),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: consentService.privacyOptionsRequired,
            builder: (context, isRequired, child) {
              if (!isRequired) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: OutlinedButton.icon(
                  onPressed: () => _showAdPrivacyOptions(context),
                  icon: const Icon(Icons.ads_click_outlined),
                  label: Text(_privacyOptionsLabel(context)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showAdPrivacyOptions(BuildContext context) async {
    final error = await AdsConsentService.instance.showPrivacyOptions();
    if (error == null || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_privacyOptionsErrorLabel(context))),
    );
  }

  String _privacyOptionsLabel(BuildContext context) {
    return switch (Localizations.localeOf(context).languageCode) {
      'de' => 'Werbe-Datenschutz verwalten',
      'es' => 'Gestionar privacidad de anuncios',
      'fr' => 'Gérer la confidentialité des annonces',
      'zh' => '管理广告隐私设置',
      _ => 'Manage ad privacy',
    };
  }

  String _privacyOptionsErrorLabel(BuildContext context) {
    return switch (Localizations.localeOf(context).languageCode) {
      'de' => 'Die Werbe-Datenschutzeinstellungen konnten nicht geöffnet werden.',
      'es' => 'No se pudo abrir la configuración de privacidad de anuncios.',
      'fr' => 'Impossible d’ouvrir les paramètres de confidentialité des annonces.',
      'zh' => '无法打开广告隐私设置。',
      _ => 'Ad privacy settings could not be opened.',
    };
  }
}
