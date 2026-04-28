import 'package:flutter/material.dart';

class AttentionWrapper extends StatefulWidget {
  final Widget child;

  const AttentionWrapper({super.key, required this.child});

  @override
  State<AttentionWrapper> createState() => _AttentionWrapperState();
}

class _AttentionWrapperState extends State<AttentionWrapper>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _tapController;

  late Animation<double> scaleAnim;
  late Animation<double> floatAnim;
  late Animation<double> tapScale;

  @override
  void initState() {
    super.initState();

    // Continuous pulse
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    scaleAnim = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    floatAnim = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Tap animation
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    tapScale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    _tapController.forward();
  }

  void _onTapUp(_) async {
    await _tapController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => _tapController.reverse(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _tapController]),
        builder: (context, child) {
          double finalScale = scaleAnim.value * tapScale.value;

          return Transform.translate(
            offset: Offset(0, floatAnim.value),
            child: Transform.scale(
              scale: finalScale,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}