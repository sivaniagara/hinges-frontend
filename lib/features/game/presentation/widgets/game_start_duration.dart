import 'dart:async';
import 'package:flutter/material.dart';

class GameStartDuration extends StatefulWidget {
  const GameStartDuration({super.key});

  @override
  State<GameStartDuration> createState() => _GameStartDurationState();
}

class _GameStartDurationState extends State<GameStartDuration> {
  int _count = 5;
  double _scale = 0.5;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  Future<void> _startCountdown() async {
    while (_count > 0) {
      setState(() {
        _count--; // decrement first
        _scale = 0.5;
        _opacity = 1.0;
      });

      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;

      setState(() {
        _scale = 1.5;
        _opacity = 0.0;
      });

      await Future.delayed(const Duration(milliseconds: 900));
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _count == 0 ? "GO!" : "$_count";

    return AnimatedOpacity(
      duration: Duration(milliseconds: _opacity == 0.0 ? 900 : 0),
      opacity: _opacity,
      child: AnimatedScale(
        duration: Duration(milliseconds: _opacity == 0.0 ? 900 : 0),
        scale: _scale,
        curve: Curves.easeOutExpo,
        child: Text(
          displayText,
          style: TextStyle(
            fontSize: _count == 0 ? 100 : 80,
            fontWeight: FontWeight.bold,
            color: _count == 0 ? Colors.yellow : Colors.white,
            letterSpacing: 4,
            shadows: const [
              Shadow(
                blurRadius: 20,
                color: Colors.orange,
                offset: Offset(0, 0),
              )
            ],
          ),
        ),
      ),
    );
  }
}