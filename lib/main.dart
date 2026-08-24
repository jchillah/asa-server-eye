// main.dart
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/ads/ads_consent_service.dart';
import 'core/ads/admob_ids.dart';
import 'core/storage/shared_preferences_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const AsaServerEyeApp(),
    ),
  );

  // Run consent handling only after the Flutter UI exists. Ad widgets remain
  // disabled until UMP explicitly allows ad requests.
  if (AdMobIds.isSupportedPlatform) {
    unawaited(AdsConsentService.instance.initialize());
  }
}
