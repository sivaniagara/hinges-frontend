import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String title;
  final List<Color> colors;
  double? fontSize;
  GradientText({super.key,
    required this.title,
    required this.colors,
    this.fontSize
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,    // starts at top
          end: Alignment.bottomCenter,   // ends at bottom
          colors: colors,
        ).createShader(bounds);          // uses actual text size automatically!
      },
      blendMode: BlendMode.srcIn,        // important for text coloring
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,           // base color (white works well with srcIn)
        ),
      ),
    );
  }
}
