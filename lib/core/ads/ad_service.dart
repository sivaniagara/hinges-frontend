import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_helper.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _isLoadingInterstitial = false;
  bool _isLoadingRewarded = false;

  bool get isInterstitialReady => _interstitialAd != null;
  bool get isRewardedReady => _rewardedAd != null;

  /// Load Interstitial. Completes with true once the ad is ready, or false
  /// if it failed to load. Safe to call repeatedly — it won't fire a
  /// duplicate request while one is already in flight or already loaded.
  Future<bool> loadInterstitial() {
    if (_isLoadingInterstitial) return Future.value(false);
    if (_interstitialAd != null) return Future.value(true);

    _isLoadingInterstitial = true;
    final completer = Completer<bool>();

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoadingInterstitial = false;
          if (!completer.isCompleted) completer.complete(true);
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed to load: $error');
          _isLoadingInterstitial = false;
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );

    return completer.future;
  }

  /// Show Interstitial. Falls back to [onAdClosed] immediately if no ad is
  /// ready (and kicks off a load so one is hopefully ready next time).
  /// Automatically preloads the next interstitial once this one closes.
  void showInterstitial({Function? onAdClosed}) {
    final ad = _interstitialAd;
    if (ad == null) {
      onAdClosed?.call();
      loadInterstitial();
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        onAdClosed?.call();
        loadInterstitial(); // preload the next one
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial failed to show: $error');
        ad.dispose();
        _interstitialAd = null;
        onAdClosed?.call();
        loadInterstitial();
      },
    );

    ad.show();
  }

  /// Load Rewarded. Completes with true once the ad is ready, or false
  /// if it failed to load.
  Future<bool> loadRewarded() {
    if (_isLoadingRewarded) return Future.value(false);
    if (_rewardedAd != null) return Future.value(true);

    _isLoadingRewarded = true;
    final completer = Completer<bool>();

    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoadingRewarded = false;
          if (!completer.isCompleted) completer.complete(true);
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded failed to load: $error');
          _isLoadingRewarded = false;
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );

    return completer.future;
  }

  /// Show Rewarded. Falls back to [onAdClosed] immediately if no ad is
  /// ready. Automatically preloads the next rewarded ad once this one closes.
  void showRewarded({
    required Function onRewardEarned,
    Function? onAdClosed,
  }) {
    final ad = _rewardedAd;
    if (ad == null) {
      onAdClosed?.call();
      loadRewarded();
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        onAdClosed?.call();
        loadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Rewarded failed to show: $error');
        ad.dispose();
        _rewardedAd = null;
        onAdClosed?.call();
        loadRewarded();
      },
    );

    ad.show(
      onUserEarnedReward: (ad, reward) {
        onRewardEarned();
      },
    );
  }

  /// Call when the owning Bloc/screen is disposed to avoid leaking ads.
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
  }
}