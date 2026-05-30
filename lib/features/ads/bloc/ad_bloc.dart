import 'package:flutter_bloc/flutter_bloc.dart';
import 'ad_event.dart';
import 'ad_state.dart';
import '../../../core/ads/ad_service.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  final AdService adService;

  AdBloc(this.adService) : super(AdInitial()) {
    on<LoadInterstitialAd>((event, emit) {
      adService.loadInterstitial();
    });

    on<ShowInterstitialAd>((event, emit) {
      adService.showInterstitial(
        onAdClosed: event.onAdClosed,
      );
    });

    on<LoadRewardedAd>((event, emit) {
      adService.loadRewarded();
    });

    on<ShowRewardedAd>((event, emit) {
      adService.showRewarded(
        onRewardEarned: event.onRewardEarned,
        onAdClosed: event.onAdClosed,
      );
    });
  }
}