// features/settings/presentation/widgets/simple_info_screen.dart
import 'package:flutter/material.dart';

class SimpleInfoScreen extends StatelessWidget {
  const SimpleInfoScreen({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SelectableText(title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          SelectableText(body, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
