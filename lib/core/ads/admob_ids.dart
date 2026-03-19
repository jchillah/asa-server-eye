// core/ads/admob_ids.dart
import 'package:flutter/foundation.dart';

class AdMobIds {
  const AdMobIds._();

  static const bool useTestAds = false;

  static bool get isSupportedPlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  static String? get banner {
    if (!isSupportedPlatform) {
      return null;
    }

    if (useTestAds) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return 'ca-app-pub-3940256099942544/6300978111';
        case TargetPlatform.iOS:
          return 'ca-app-pub-3940256099942544/2934735716';
        default:
          return null;
      }
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'ca-app-pub-7269049262039376/8103339657';
      case TargetPlatform.iOS:
        return 'ca-app-pub-7269049262039376/7438324350';
      default:
        return null;
    }
  }
}
