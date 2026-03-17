// features/settings/presentation/screens/support_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_contact.dart';
import '../../../../core/extensions/context_l10n.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _sendEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: AppContact.supportEmail,
      queryParameters: {
        'subject': context.l10n.supportEmailSubject,
        'body': context.l10n.supportEmailBodyTemplate,
      },
    );

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.emailAppCouldNotBeOpened)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.support)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SelectableText(
            context.l10n.supportBody,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _sendEmail(context),
            icon: const Icon(Icons.email_outlined),
            label: Text(context.l10n.contactSupport),
          ),
        ],
      ),
    );
  }
}
