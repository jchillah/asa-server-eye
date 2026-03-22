// features/settings/presentation/utils/settings_navigation.dart
import 'package:flutter/material.dart';

import '../screens/about_screen.dart';
import '../screens/imprint_screen.dart';
import '../screens/privacy_screen.dart';
import '../screens/support_screen.dart';

abstract final class SettingsNavigation {
  static Future<void> openAbout(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AboutScreen()));
  }

  static Future<void> openPrivacy(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PrivacyScreen()));
  }

  static Future<void> openImprint(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ImprintScreen()));
  }

  static Future<void> openSupport(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SupportScreen()));
  }
}
