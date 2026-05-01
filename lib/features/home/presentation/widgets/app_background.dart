import 'package:flutter/material.dart';

import '../../../login/presentation/widgets/mandala_background.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool animateContent;
  const AppBackground({super.key, required this.child, this.animateContent = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF020617)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: MandalaBackground(animateContent: animateContent,child: child,),
    );
  }
}