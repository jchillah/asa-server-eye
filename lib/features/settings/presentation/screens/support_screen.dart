// features/settings/presentation/screens/support_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/context_l10n.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const _email = 'michael.winkler.developer@gmail.com';

  Future<void> _sendEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _email,
      queryParameters: {
        'subject': 'ASA Server Eye Support',
        'body':
            'Hallo Michael,\n\nich habe folgendes Problem:\n\n\n---\nApp Version:\nGerät:\n',
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-Mail App konnte nicht geöffnet werden'),
        ),
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

          ElevatedButton.icon(
            onPressed: () => _sendEmail(context),
            icon: const Icon(Icons.email),
            label: const Text('Support kontaktieren'),
          ),
        ],
      ),
    );
  }
}
