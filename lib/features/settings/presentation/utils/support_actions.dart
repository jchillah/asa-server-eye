// features/settings/presentation/utils/support_actions.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_contact.dart';
import '../../../../core/extensions/context_l10n.dart';
import 'settings_links.dart';

abstract final class SupportActions {
  static Future<void> sendSupportEmail(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    final uri = Uri(
      scheme: 'mailto',
      path: AppContact.supportEmail,
      queryParameters: {
        'subject': context.l10n.supportEmailSubject,
        'body': context.l10n.supportEmailBodyTemplate,
      },
    );

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(context.l10n.emailAppCouldNotBeOpened)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(context.l10n.emailAppCouldNotBeOpened)),
        );
      }
    }
  }

  static Future<void> openPrivacyPolicy() async {
    final uri = Uri.parse(SettingsLinks.privacyPolicy);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> openDeleteAccount() async {
    final uri = Uri.parse(SettingsLinks.deleteAccount);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
