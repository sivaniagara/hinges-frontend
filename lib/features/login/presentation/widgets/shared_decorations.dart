import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';

import '../../../../core/theme/app_theme.dart';

class GoldenTitle extends StatelessWidget {
  final String title;
  final double fontSize;

  const GoldenTitle({
    super.key,
    required this.title,
    this.fontSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFFB26D01),
          AppTheme.borderGold,
          AppTheme.borderGold,
          Color(0xFFB26D01),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.cinzel(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          shadows: [
            Shadow(
              offset: const Offset(0, 6),
              blurRadius: 8,
              color: Colors.black.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class GoldenSubtitle extends StatelessWidget {
  final String title;
  final double fontSize;

  const GoldenSubtitle({
    super.key,
    required this.title,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFFFDFFAF),
          Color(0xFFFDFFAF),
          AppTheme.borderGold,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.cinzel(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          shadows: [
            Shadow(
              offset: const Offset(0, 6),
              blurRadius: 8,
              color: Colors.black.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class StarLine extends StatelessWidget {
  final double fontSize;
  const StarLine({super.key,
    this.fontSize = 20
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.goldenStarLine,
          width: 50,
        ),
        GoldenSubtitle(
          title: 'OWN YOUR DREAM TEAM',
          fontSize: fontSize,
        ),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Image.asset(
            AppImages.goldenStarLine,
            width: 50,
          ),
        ),
      ],
    );
  }
}

class MandalaDecoration extends StatelessWidget {
  final Alignment alignment;
  final double rotateX;
  final double rotateY;
  final double opacity;
  final double size;

  const MandalaDecoration({
    super.key,
    required this.alignment,
    this.rotateX = 0,
    this.rotateY = 0,
    this.opacity = 0.5,
    this.size = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(rotateX)..rotateY(rotateY),
          child: Opacity(
            opacity: opacity,
            child: Image.asset(
              AppImages.mandalaPattern,
              width: MediaQuery.of(context).size.height * size,
            ),
          ),
        ),
      ),
    );
  }
}

class GoldenRingBackground extends StatelessWidget {
  const GoldenRingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.5,
        child: Image.asset(
          AppImages.goldenRingStump,
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }
}

class GoldenCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double? width;

  const GoldenCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(25),
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }
}