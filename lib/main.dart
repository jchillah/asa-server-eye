// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/app.dart';
import 'core/ads/admob_ids.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialisieren
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Google Mobile Ads initialisieren (Release: useTestAds=false)
  if (AdMobIds.isSupportedPlatform) {
    await MobileAds.instance.initialize();
    // Hinweis: Testgeräte-Konfiguration entfernen für Release
    // await MobileAds.instance.updateRequestConfiguration(
    //   RequestConfiguration(testDeviceIds: ['TEST_DEVICE_ID']),
    // );
  }

  runApp(const ProviderScope(child: AsaServerEyeApp()));
}
