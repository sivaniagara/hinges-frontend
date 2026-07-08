import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';

class CurrencyBar extends StatefulWidget {
  final String icon;
  final int value;
  final VoidCallback? onAddTap;

  const CurrencyBar({
    super.key,
    required this.icon,
    required this.value,
    this.onAddTap,
  });

  @override
  State<CurrencyBar> createState() => _CurrencyBarState();
}

class _CurrencyBarState extends State<CurrencyBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bumpController;
  late final Animation<double> _bumpScale;

  @override
  void initState() {
    super.initState();
    _bumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _bumpScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.35, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 55,
      ),
    ]).animate(_bumpController);
  }

  @override
  void didUpdateWidget(covariant CurrencyBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Pop the coin count whenever it goes up (e.g. reward landed).
    if (widget.value > oldWidget.value) {
      _bumpController.forward(from: 0);
    }
  }

  /// Lets external code (e.g. the coin-burst overlay) trigger the pop
  /// manually, in case you want it timed with the coins landing rather
  /// than with the value actually changing.
  void playBump() => _bumpController.forward(from: 0);

  @override
  void dispose() {
    _bumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.navyBlue,
        border: Border.all(color: AppTheme.borderGold),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(widget.icon, width: 25),

          const SizedBox(width: 8),

          /// VALUE
          AnimatedBuilder(
            animation: _bumpScale,
            builder: (context, child) {
              return Transform.scale(
                scale: _bumpScale.value,
                child: child,
              );
            },
            child: Text(
              widget.value.toString(),
              style: GoogleFonts.rajdhani(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 8),

          /// ADD BUTTON
          GestureDetector(
            onTap: widget.onAddTap,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.borderGold,
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.add,
                size: 16,
                color: AppTheme.borderGold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}