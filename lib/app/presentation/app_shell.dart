// app/presentation/app_shell.dart
import 'package:ark_server_eye/app/presentation/widgets/app_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/servers/presentation/screens/server_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  late final List<Widget> _screens = const [
    ServerListScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
