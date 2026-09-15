import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/features/login/presentation/widgets/mandala_background.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_sounds.dart';
import '../../../../core/utils/audio_manager.dart';
import '../../../../core/utils/so_loud.dart';
import '../../../login/presentation/widgets/shared_decorations.dart';
import '../../domain/entities/user_data_entity.dart';
import '../widgets/app_background.dart';

class ShopScreen extends StatelessWidget {
  final UserDataEntity userData;
  const ShopScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: MandalaBackground(
        animateContent: false,
        backGroundColor: AppTheme.deepNavy,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 0,
                      child: Image.asset(AppImages.shopMenuIcon, width: 60),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.goldenStarLine,
                                width: 50,
                              ),
                              const GoldenTitle(
                                title: 'SHOP',
                                fontSize: 32,
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
                        ],
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Image.asset(AppImages.backMenuIcon, width: 60),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: size.width * 0.8,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 1. Navy background — sized slightly INSIDE the frame's gold line
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(6), // tune to match your frame's stroke thickness
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.deepNavy,
                            borderRadius: BorderRadius.circular(36), // slightly smaller than frame's corner radius
                          ),
                        ),
                      ),
                    ),

                    // 2. Golden frame drawn on top, untouched, at full size
                    Positioned.fill(
                      child: Image.asset(
                        AppImages.goldenOutline,
                        fit: BoxFit.fill,
                      ),
                    ),

                    // 3. Actual content, padded inward from the edges
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Container(
                            width: 200,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(AppImages.titleGoldenFrame),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Text(
                              'BUY COINS',
                              style: GoogleFonts.rajdhani(
                                color: AppTheme.borderGold,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          // Coin Packages
                          ShopItemCard(
                            price: '10',
                            coins: '500',
                            image: AppImages.coinsIcon,
                            locked: true,
                          ),
                          ShopItemCard(
                            price: '50',
                            coins: '2,500',
                            image: AppImages.coinsIcon,
                            locked: true,
                          ),
                          ShopItemCard(
                            price: '99',
                            coins: '10,000',
                            image: AppImages.coinsIcon,
                            locked: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopItem({
    required String price,
    required String coins,
    required String image,
  }) {
    return Container(
      height: 55,
      width: 400,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppImages.goldenChamberFrame),
              fit: BoxFit.fill
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: 40, height: 45),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'Rs. ',
                      style: GoogleFonts.rajdhani(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.rajdhani(
                        color: AppTheme.borderGold,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  AppImages.highlightValue,
                  width: 80,
                  height: 10,
                  fit: BoxFit.fitHeight,
                )
              ],
            ),
          ),
          Transform.rotate(
            angle: 90 * 3.1415926535 / 180, // 90 degrees in radians
            child: Image.asset(
              AppImages.highlightValue,
              width: 60,
            ),
          ),
          // Coins Section
          SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  coins,
                  style: GoogleFonts.rajdhani(
                    color: AppTheme.borderGold,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'COINS',
                  style: GoogleFonts.rajdhani(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.lock, color: AppTheme.borderGold, size: 18),
        ],
      ),
    );
  }
}

class ShopItemCard extends StatefulWidget {
  final String price;
  final String coins;
  final String image;
  final bool locked;
  final VoidCallback? onTap;

  const ShopItemCard({
    super.key,
    required this.price,
    required this.coins,
    required this.image,
    this.locked = false,
    this.onTap,
  });

  @override
  State<ShopItemCard> createState() => _ShopItemCardState();
}

class _ShopItemCardState extends State<ShopItemCard>
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
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8, end: -6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -6, end: 4), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 4, end: -2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -2, end: 0), weight: 1),
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
    if (widget.locked) {
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
          height: 55,
          width: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.goldenChamberFrame),
              fit: BoxFit.fill,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.image, width: 40, height: 45),
              SizedBox(
                width: 100,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Rs. ',
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.price,
                          style: GoogleFonts.rajdhani(
                            color: AppTheme.borderGold,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      AppImages.highlightValue,
                      width: 80,
                      height: 10,
                      fit: BoxFit.fitHeight,
                    ),
                  ],
                ),
              ),
              Transform.rotate(
                angle: 90 * 3.1415926535 / 180,
                child: Image.asset(
                  AppImages.highlightValue,
                  width: 60,
                ),
              ),
              /// Coins Section
              SizedBox(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.coins,
                      style: GoogleFonts.rajdhani(
                        color: AppTheme.borderGold,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'COINS',
                      style: GoogleFonts.rajdhani(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.locked)
                Icon(Icons.lock, color: AppTheme.borderGold, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
