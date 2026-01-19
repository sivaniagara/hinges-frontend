import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/color_utils.dart';

class AdaptiveStatusBar extends StatelessWidget {
  final Color color;
  final Widget child;

  const AdaptiveStatusBar({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = isLightColor(color) ? Brightness.dark : Brightness.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarIconBrightness: brightness, // Android
        statusBarBrightness: brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark, // iOS
      ),
      child: child,
    );
  }
}
