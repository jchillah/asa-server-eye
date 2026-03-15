// app/app.dart
import 'package:flutter/material.dart';

import '../features/favorites/presentation/screens/favorites_screen.dart';
import '../features/servers/presentation/screens/server_list_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';

class AsaServerEyeApp extends StatefulWidget {
  const AsaServerEyeApp({super.key});

  @override
  State<AsaServerEyeApp> createState() => _AsaServerEyeAppState();
}

class _AsaServerEyeAppState extends State<AsaServerEyeApp> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ServerListScreen(),
      const FavoritesScreen(),
      const SettingsScreen(),
    ];

    return MaterialApp(
      title: 'ASA Server Eye',
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: IndexedStack(index: currentIndex, children: screens),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dns_outlined),
              selectedIcon: Icon(Icons.dns),
              label: 'Servers',
            ),
            NavigationDestination(
              icon: Icon(Icons.star_border),
              selectedIcon: Icon(Icons.star),
              label: 'Favorites',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
