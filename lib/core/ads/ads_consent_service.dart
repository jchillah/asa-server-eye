import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admob_ids.dart';

/// Coordinates Google UMP consent and Mobile Ads initialization.
///
/// Ads are never initialized or requested until UMP reports that ad requests
/// are allowed. Consent information is refreshed on every app launch as
/// recommended by Google.
class AdsConsentService {
  AdsConsentService._();

  static final AdsConsentService instance = AdsConsentService._();

  final ValueNotifier<bool> canRequestAds = ValueNotifier<bool>(false);
  final ValueNotifier<bool> privacyOptionsRequired = ValueNotifier<bool>(false);

  bool _mobileAdsInitialized = false;
  Future<void>? _initialization;

  Future<void> initialize() {
    if (!AdMobIds.isSupportedPlatform) {
      return Future<void>.value();
    }

    return _initialization ??= _initializeInternal();
  }

  Future<void> _initializeInternal() async {
    final completer = Completer<void>();

    void completeOnce() {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () {
        ConsentForm.loadAndShowConsentFormIfRequired((formError) async {
          if (formError != null) {
            debugPrint(
              'UMP consent form error ${formError.errorCode}: '
              '${formError.message}',
            );
          }
          await _refreshState();
          completeOnce();
        });
      },
      (formError) async {
        debugPrint(
          'UMP consent info error ${formError.errorCode}: ${formError.message}',
        );
        // A previous valid consent state may still allow ads even when the
        // network refresh fails, so always ask UMP for the effective state.
        await _refreshState();
        completeOnce();
      },
    );

    try {
      await completer.future.timeout(const Duration(seconds: 15));
    } on TimeoutException {
      debugPrint('UMP consent initialization timed out; ads remain disabled.');
      await _refreshState();
    }
  }

  Future<void> _refreshState() async {
    final allowed = await ConsentInformation.instance.canRequestAds();
    final privacyStatus = await ConsentInformation.instance
        .getPrivacyOptionsRequirementStatus();

    privacyOptionsRequired.value =
        privacyStatus == PrivacyOptionsRequirementStatus.required;
    canRequestAds.value = allowed;

    if (allowed && !_mobileAdsInitialized) {
      await MobileAds.instance.initialize();
      _mobileAdsInitialized = true;
    }
  }

  Future<FormError?> showPrivacyOptions() async {
    final completer = Completer<FormError?>();

    ConsentForm.showPrivacyOptionsForm((formError) async {
      await _refreshState();
      if (!completer.isCompleted) {
        completer.complete(formError);
      }
    });

    return completer.future;
  }
}
