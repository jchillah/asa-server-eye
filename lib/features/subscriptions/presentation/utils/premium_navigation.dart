// features/subscriptions/presentation/utils/premium_navigation.dart
import 'package:flutter/material.dart';

import '../screens/premium_screen.dart';

abstract final class PremiumNavigation {
  static Future<void> open(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PremiumScreen()));
  }
}
