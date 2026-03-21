// app/presentation/models/app_navigation_destination_item.dart
import 'package:flutter/material.dart';

class AppNavigationDestinationItem {
  const AppNavigationDestinationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
