// features/profile/presentation/utils/profile_navigation.dart
import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';

abstract final class ProfileNavigation {
  static Future<void> openProfile(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }
}
