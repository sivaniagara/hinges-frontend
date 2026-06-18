import 'package:flutter_bloc/flutter_bloc.dart';
import 'ad_event.dart';
import 'ad_state.dart';
import '../../../core/ads/ad_service.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  final AdService adService;

  AdBloc(this.adService) : super(AdInitial()) {
    on<LoadInterstitialAd>((event, emit) async {
      emit(InterstitialAdLoading());
      final loaded = await adService.loadInterstitial();
      emit(loaded ? InterstitialAdReady() : InterstitialAdFailedToLoad());
    });

    on<ShowInterstitialAd>((event, emit) {
      adService.showInterstitial(
        onAdClosed: event.onAdClosed,
      );
    });

    on<LoadRewardedAd>((event, emit) async {
      emit(RewardedAdLoading());
      final loaded = await adService.loadRewarded();
      emit(loaded ? RewardedAdReady() : RewardedAdFailedToLoad());
    });

    on<ShowRewardedAd>((event, emit) {
      adService.showRewarded(
        onRewardEarned: event.onRewardEarned,
        onAdClosed: event.onAdClosed,
      );
    });
  }
}