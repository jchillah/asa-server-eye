// core/widgets/ad_banner_widget.dart
import 'package:asa_server_eye/core/ads/ads_consent_service.dart';
import 'package:asa_server_eye/core/ads/admob_ids.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  late final AdsConsentService _consentService;

  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _consentService = AdsConsentService.instance;
    _consentService.canRequestAds.addListener(_handleConsentChanged);
    _handleConsentChanged();
  }

  void _handleConsentChanged() {
    if (!_consentService.canRequestAds.value) {
      _disposeBanner();
      return;
    }

    if (!_isLoaded && !_isLoading) {
      _loadBanner();
    }
  }

  void _loadBanner() {
    final adUnitId = AdMobIds.banner;

    if (adUnitId == null || !_consentService.canRequestAds.value) {
      return;
    }

    _isLoading = true;

    final bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted || !_consentService.canRequestAds.value) {
            _isLoading = false;
            ad.dispose();
            return;
          }

          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
            _isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          _isLoading = false;
          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }

  void _disposeBanner() {
    final shouldNotify = _bannerAd != null || _isLoaded || _isLoading;
    final ad = _bannerAd;
    _bannerAd = null;
    _isLoaded = false;
    _isLoading = false;
    ad?.dispose();

    if (mounted && shouldNotify) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _consentService.canRequestAds.removeListener(_handleConsentChanged);
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AdMobIds.isSupportedPlatform) {
      return const SizedBox.shrink();
    }

    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
