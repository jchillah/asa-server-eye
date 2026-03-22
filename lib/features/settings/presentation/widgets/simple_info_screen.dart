// features/settings/presentation/widgets/simple_info_screen.dart
import 'package:flutter/material.dart';

class SimpleInfoScreen extends StatelessWidget {
  const SimpleInfoScreen({
    super.key,
    required this.title,
    required this.body,
    this.bottom,
  });

  final String title;
  final String body;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SelectableText(body, style: Theme.of(context).textTheme.bodyLarge),
          ?bottom,
        ],
      ),
    );
  }
}
