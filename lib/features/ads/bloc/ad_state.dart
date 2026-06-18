abstract class AdState {}

class AdInitial extends AdState {}

// Interstitial
class InterstitialAdLoading extends AdState {}
class InterstitialAdReady extends AdState {}
class InterstitialAdFailedToLoad extends AdState {}

// Rewarded
class RewardedAdLoading extends AdState {}
class RewardedAdReady extends AdState {}
class RewardedAdFailedToLoad extends AdState {}