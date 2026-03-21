// app/presentation/app_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/servers/presentation/screens/server_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import 'controllers/app_shell_controller.dart';
import 'widgets/app_bottom_navigation_bar.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  static const List<Widget> _screens = [
    ServerListScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(appShellIndexProvider);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: currentIndex,
        onDestinationSelected: ref
            .read(appShellIndexProvider.notifier)
            .setIndex,
      ),
    );
  }
}
