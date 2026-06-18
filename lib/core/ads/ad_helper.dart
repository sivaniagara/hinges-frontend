import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {
  // NOTE: replace the "real ID" placeholders below with your actual AdMob
  // ad unit IDs before release. The IDs used in debug mode are Google's
  // official public test IDs — safe to ship in debug builds, never use them
  // in production (and never use your real production IDs while testing).

  static String get bannerAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    return Platform.isAndroid
        ? 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY' // TODO: real Android banner ID
        : 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY'; // TODO: real iOS banner ID
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';
    }
    return Platform.isAndroid
        ? 'ca-app-pub-7979959248957095/2081180497' // TODO: real Android interstitial ID
        : 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY'; // TODO: real iOS interstitial ID
  }

  static String get rewardedAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    }
    return Platform.isAndroid
        ? 'ca-app-pub-7979959248957095/9755319670' // TODO: real Android rewarded ID
        : 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY'; // TODO: real iOS rewarded ID
  }
}