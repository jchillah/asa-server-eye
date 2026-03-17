// core/ads/admob_ids.dart
import 'dart:io';

class AdMobIds {
  const AdMobIds._();

  /// Während der Entwicklung auf `true` lassen.
  /// Erst kurz vor echtem Release auf `false` stellen.
  static const bool useTestAds = true;

  static String get banner {
    if (useTestAds) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      }

      if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    } else {
      if (Platform.isAndroid) {
        return 'ca-app-pub-7269049262039376/8103339657';
      }

      if (Platform.isIOS) {
        return 'ca-app-pub-7269049262039376/7438324350';
      }
    }

    throw UnsupportedError('Banner ads are only supported on Android and iOS.');
  }
}
