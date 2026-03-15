// app/app.dart
import 'package:flutter/material.dart';

import '../features/servers/presentation/screens/server_list_screen.dart';

class AsaServerEyeApp extends StatelessWidget {
  const AsaServerEyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASA Server Eye',
      theme: ThemeData(useMaterial3: true),
      home: const ServerListScreen(),
    );
  }
}
