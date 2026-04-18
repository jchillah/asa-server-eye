// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/app.dart';
import 'core/ads/admob_ids.dart';
import 'firebase_options.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Firebase initialisieren
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Google Mobile Ads initialisieren (Release: useTestAds=false)
  if (AdMobIds.isSupportedPlatform) {
    await MobileAds.instance.initialize();
  }

  runApp(const ProviderScope(child: AsaServerEyeApp()));
}
