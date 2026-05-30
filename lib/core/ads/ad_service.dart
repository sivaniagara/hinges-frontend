import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_helper.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  /// Load Interstitial
  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print("Interstitial failed: $error");
        },
      ),
    );
  }

  /// Show Interstitial
  void showInterstitial({Function? onAdClosed}) {
    if (_interstitialAd == null) {
      onAdClosed?.call();
      return;
    }

    _interstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _interstitialAd = null;

            // ✅ Trigger next action AFTER ad closes
            onAdClosed?.call();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _interstitialAd = null;

            onAdClosed?.call();
          },
        );

    _interstitialAd!.show();
  }

  /// Load Rewarded
  void loadRewarded() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          print("Rewarded failed: $error");
        },
      ),
    );
  }

  /// Show Rewarded
  void showRewarded({
    required Function onRewardEarned,
    Function? onAdClosed,
  }) {
    if (_rewardedAd == null) {
      onAdClosed?.call();
      return;
    }

    _rewardedAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _rewardedAd = null;

            // ✅ Ad closed
            onAdClosed?.call();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _rewardedAd = null;

            onAdClosed?.call();
          },
        );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        // ✅ Reward earned
        onRewardEarned();
      },
    );
  }
}