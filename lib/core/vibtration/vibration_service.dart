import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

abstract class IVibrationService {
  Future<void> vibrate({int duration});
  Future<void> hapticFeedback(HapticType type);
}

enum HapticType { light, medium, heavy, selection, vibrate }

class VibrationService implements IVibrationService {
  @override
  Future<void> vibrate({int duration = 500}) async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: duration);
    }
  }

  @override
  Future<void> hapticFeedback(HapticType type) async {
    switch (type) {
      case HapticType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticType.selection:
        HapticFeedback.selectionClick();
        break;
      case HapticType.vibrate:
        HapticFeedback.vibrate();
        break;
    }
  }
}
