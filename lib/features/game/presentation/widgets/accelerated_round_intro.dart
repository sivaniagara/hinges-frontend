import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AcceleratedRoundIntro extends StatefulWidget {
  const AcceleratedRoundIntro({super.key});

  @override
  State<AcceleratedRoundIntro> createState() =>
      _AcceleratedRoundIntroState();
}

class _AcceleratedRoundIntroState extends State<AcceleratedRoundIntro>
    with SingleTickerProviderStateMixin {
  double _scale = 0.8;
  double _opacity = 0.0;
  double _glow = 10;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    setState(() {
      _opacity = 1.0;
      _scale = 1.2;
      _glow = 30;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // Pulse effect loop
    while (mounted) {
      setState(() {
        _scale = 1.1;
        _glow = 15;
      });

      await Future.delayed(const Duration(milliseconds: 400));

      setState(() {
        _scale = 1.2;
        _glow = 30;
      });

      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 600),
        opacity: _opacity,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 400),
          scale: _scale,
          curve: Curves.easeOutExpo,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔥 Main Title
              Text(
                "ACCELERATED",
                textAlign: TextAlign.center,
                style: GoogleFonts.jost(textStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Colors.redAccent,
                  shadows: [
                    Shadow(
                      blurRadius: _glow,
                      color: Colors.red,
                    ),
                  ],
                )),
              ),

              Text(
                "ROUND",
                textAlign: TextAlign.center,
                style: GoogleFonts.jost(textStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Colors.orangeAccent,
                  shadows: [
                    Shadow(
                      blurRadius: _glow,
                      color: Colors.orange,
                    ),
                  ],
                )),
              ),

              const SizedBox(height: 20),

              // ⚡ Subtitle
              AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: _opacity,
                child: Text(
                  "Second Chance to Grab Missed Players",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jost(textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    letterSpacing: 1.5,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}