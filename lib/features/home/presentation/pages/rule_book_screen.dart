import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_sounds.dart';
import '../../../../core/utils/audio_manager.dart';
import '../../../../core/utils/so_loud.dart';
import '../../../login/presentation/widgets/mandala_background.dart';
import '../../../login/presentation/widgets/shared_decorations.dart';
import '../widgets/app_background.dart';

class RuleBookScreen extends StatelessWidget {
  const RuleBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: MandalaBackground(
        animateContent: false,
        backGroundColor: Colors.black,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(height: 10),

              /// 🔹 HEADER
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 0,
                      child: Image.asset(AppImages.ruleBookMenuIcon, width: 60),
                    ),
                    Center(
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppImages.goldenStarLine, width: 50),
                          const GoldenTitle(
                            title: 'RULE BOOK',
                            fontSize: 30,
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
                      ),
                    ),

                    /// 🔹 HOME BUTTON
                    Positioned(
                      right: 20,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          playTap();
                          context.pop();
                        },
                        child: Image.asset(
                          AppImages.backMenuIcon,
                          width: 60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 GRID CARDS
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 550,
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 2.6,
                      children: [
                        RuleCard(
                          title1: "MINI AUCTION",
                          title2: "LITE",
                          isLocked: false,
                          image: AppImages.blueCard,
                          onTap: () {
                            playTap();
                            context.push('/ruleBook/miniAuctionLiteRuleBook');
                          },
                        ),
                        RuleCard(
                          title1: "MINI AUCTION",
                          title2: "PRO",
                          isLocked: true,
                          image: AppImages.greenCard,
                        ),
                        RuleCard(
                          title1: "MEGA AUCTION",
                          title2: "LITE",
                          isLocked: true,
                          image: AppImages.violetCard,
                        ),
                        RuleCard(
                          title1: "MEGA AUCTION",
                          title2: "PRO",
                          isLocked: true,
                          image: AppImages.redCard,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= RULE CARD =================
class RuleCard extends StatefulWidget {
  final String title1;
  final String title2;
  final bool isLocked;
  final String image;
  final VoidCallback? onTap;

  const RuleCard({
    super.key,
    required this.title1,
    required this.title2,
    required this.isLocked,
    required this.image,
    this.onTap,
  });

  @override
  State<RuleCard> createState() => _RuleCardState();
}

class _RuleCardState extends State<RuleCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    // Damped oscillation: a few back-and-forth wiggles that settle down.
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 6, end: -3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -3, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isLocked) {
      // Give feedback that this card is locked instead of doing nothing.
      HapticFeedback.mediumImpact();
      _shakeController.forward(from: 0);
      return;
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.image),
              fit: BoxFit.fill,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              /// 🔹 ICON
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  AppImages.ruleBookMenuIcon,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 10),

              /// 🔹 TEXT
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.title1,
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' ${widget.title2}',
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "RULE BOOK",
                      style: GoogleFonts.rajdhani(
                          color: AppTheme.borderGold,
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔹 LOCK ICON
              if (widget.isLocked)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.lock,
                    color: AppTheme.borderGold,
                    size: 18,
                  ),
                ),

              /// 🔹 ARROW
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.borderGold,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}