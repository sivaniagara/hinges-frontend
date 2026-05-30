abstract class AdEvent {}

class LoadInterstitialAd extends AdEvent {}
class ShowInterstitialAd extends AdEvent {
  final Function? onAdClosed;

  ShowInterstitialAd({this.onAdClosed});
}
class LoadRewardedAd extends AdEvent {}
class ShowRewardedAd extends AdEvent {
  final Function onRewardEarned;
  final Function? onAdClosed;

  ShowRewardedAd({
    required this.onRewardEarned,
    this.onAdClosed,
  });
}