import 'package:flutter/material.dart';

class AsaServerEyeApp extends StatelessWidget {
  const AsaServerEyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASA Server Eye',
      home: Scaffold(
        appBar: AppBar(title: const Text('ASA Server Eye')),
        body: const Center(
          child: Text('ASA Server Eye MVP'),
        ),
      ),
    );
  }
}
