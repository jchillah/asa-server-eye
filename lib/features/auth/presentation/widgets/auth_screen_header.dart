// features/auth/presentation/widgets/auth_screen_header.dart
import 'package:flutter/material.dart';

class AuthScreenHeader extends StatelessWidget {
  const AuthScreenHeader({
    super.key,
    this.icon,
    this.imagePath,
    required this.title,
    required this.subtitle,
  });

  final IconData? icon;
  final String? imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    final logoSize = screenWidth * 0.5;

    Widget leading;

    if (imagePath != null) {
      leading = Image.asset(
        imagePath!,
        width: logoSize,
        height: logoSize,
        fit: BoxFit.contain,
      );
    } else {
      leading = Icon(icon, size: 56);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: leading),

        const SizedBox(height: 24),

        Text(title, style: theme.textTheme.headlineSmall),

        const SizedBox(height: 8),

        Text(subtitle, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
