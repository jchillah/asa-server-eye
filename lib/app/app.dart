// app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/presentation/l10n/locale_controller.dart';
import '../features/auth/presentation/screens/auth_gate.dart';
import '../l10n/app_localizations.dart';
import 'theme/app_theme.dart';

class AsaServerEyeApp extends ConsumerStatefulWidget {
  const AsaServerEyeApp({super.key});

  @override
  ConsumerState<AsaServerEyeApp> createState() => _AsaServerEyeAppState();
}

class _AsaServerEyeAppState extends ConsumerState<AsaServerEyeApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const AuthGate(),
    );
  }
}
