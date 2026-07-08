import 'dart:math';
import 'package:flutter/material.dart';

/// ================= COIN BURST OVERLAY =================
///
/// Fires a burst of coin icons that fly from [startPosition] (or the
/// widget behind [sourceKey]) to the widget behind [targetKey] — e.g.
/// the CurrencyBar in TopUserBar — using an arced "toss" trajectory
/// with a shrink + fade "absorb" finish.
///
/// Usage:
/// ```dart
/// CoinBurstOverlay.show(
///   context,
///   targetKey: currencyBarKey,
///   startPosition: Offset(size.width / 2, size.height / 2),
///   coinCount: 10,
///   coinAsset: AppImages.coinMenuIcon,
///   onCoinLanded: () {
///     // e.g. trigger a little bounce/scale pulse on the coin count text
///   },
/// );
/// ```
class CoinBurstOverlay {
  CoinBurstOverlay._();

  /// Shows the coin burst animation.
  ///
  /// Provide either [startPosition] OR [sourceKey] (one of them is
  /// required) as the origin of the coins, and [targetKey] as the
  /// widget the coins should fly into (its center is used).
  ///
  /// [onCoinLanded] is called once per coin exactly when it reaches
  /// the target (use it to "bump" the coin counter / play a sound).
  /// [onComplete] is called once, after the *last* coin finishes.
  static void show(
      BuildContext context, {
        required GlobalKey targetKey,
        GlobalKey? sourceKey,
        Offset? startPosition,
        required String coinAsset,
        int coinCount = 10,
        Duration baseDuration = const Duration(milliseconds: 700),
        Duration staggerDelay = const Duration(milliseconds: 55),
        double coinSize = 26,
        VoidCallback? onCoinLanded,
        VoidCallback? onComplete,
      }) {
    assert(
    startPosition != null || sourceKey != null,
    'Provide either startPosition or sourceKey',
    );

    final overlay = Overlay.of(context, rootOverlay: true);

    final targetBox =
    targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (targetBox == null || !targetBox.attached) return;
    final targetCenter = targetBox.localToGlobal(
      targetBox.size.center(Offset.zero),
    );

    Offset origin;
    if (startPosition != null) {
      origin = startPosition;
    } else {
      final sourceBox =
      sourceKey!.currentContext?.findRenderObject() as RenderBox?;
      if (sourceBox == null || !sourceBox.attached) return;
      origin = sourceBox.localToGlobal(sourceBox.size.center(Offset.zero));
    }

    late OverlayEntry entry;
    int completedCoins = 0;

    entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: List.generate(coinCount, (index) {
            // Small random spread so coins don't all overlap perfectly.
            final rand = Random(index * 997 + index);
            final spread = Offset(
              (rand.nextDouble() - 0.5) * 60,
              (rand.nextDouble() - 0.5) * 30,
            );
            final arcHeight = 90 + rand.nextDouble() * 60;
            final delay = staggerDelay * index;
            final duration = baseDuration +
                Duration(milliseconds: rand.nextInt(150));

            return _FlyingCoin(
              start: origin + spread,
              end: targetCenter,
              arcHeight: arcHeight,
              delay: delay,
              duration: duration,
              size: coinSize,
              asset: coinAsset,
              onLanded: () {
                onCoinLanded?.call();
                completedCoins++;
                if (completedCoins == coinCount) {
                  onComplete?.call();
                  entry.remove();
                }
              },
            );
          }),
        );
      },
    );

    overlay.insert(entry);
  }
}

/// ================= SINGLE FLYING COIN =================
class _FlyingCoin extends StatefulWidget {
  final Offset start;
  final Offset end;
  final double arcHeight;
  final Duration delay;
  final Duration duration;
  final double size;
  final String asset;
  final VoidCallback onLanded;

  const _FlyingCoin({
    required this.start,
    required this.end,
    required this.arcHeight,
    required this.delay,
    required this.duration,
    required this.size,
    required this.asset,
    required this.onLanded,
  });

  @override
  State<_FlyingCoin> createState() => _FlyingCoinState();
}

class _FlyingCoinState extends State<_FlyingCoin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeInCubic);

    Future.delayed(widget.delay, () {
      if (!mounted) return;
      setState(() => _started = true);
      _controller.forward().then((_) {
        if (mounted) widget.onLanded();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) {
        final t = _progress.value;

        // Linear interpolation toward the target...
        final dx = widget.start.dx + (widget.end.dx - widget.start.dx) * t;
        final dy = widget.start.dy + (widget.end.dy - widget.start.dy) * t;

        // ...plus an upward arc bump (toss-then-drop feel).
        final arc = -widget.arcHeight * sin(pi * t);

        // Pop in quickly, then shrink as it gets "absorbed" near the end.
        final scale = t < 0.15
            ? (0.4 + (t / 0.15) * 0.8) // 0.4 -> 1.2 pop
            : t < 0.8
            ? 1.2 - ((t - 0.15) / 0.65) * 0.3 // settle to 0.9
            : 0.9 - ((t - 0.8) / 0.2) * 0.7; // shrink to 0.2 near landing

        // Fade out only in the last stretch, right as it's absorbed.
        final opacity = t < 0.85 ? 1.0 : (1 - (t - 0.85) / 0.15).clamp(0.0, 1.0);

        return Positioned(
          left: dx - widget.size / 2,
          top: dy + arc - widget.size / 2,
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Image.asset(
                widget.asset,
                width: widget.size,
                height: widget.size,
              ),
            ),
          ),
        );
      },
    );
  }
}