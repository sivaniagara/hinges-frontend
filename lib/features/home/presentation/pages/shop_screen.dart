import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
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
      child: AppBackground(
        animateContent: false,
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
                        onTap: () => context.pop(),
                        child: Image.asset(AppImages.homeMenuIcon, width: 60),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width * 0.8,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppTheme.navyBlue,
                    image: DecorationImage(
                        image: AssetImage(AppImages.goldenOutline),
                        fit: BoxFit.fill
                    )
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                        style: GoogleFonts.cinzel(
                          color: AppTheme.borderGold,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    // Coin Packages
                    _buildShopItem(
                      price: '10',
                      coins: '500',
                      image: AppImages.coinsIcon,
                    ),
                    _buildShopItem(
                      price: '50',
                      coins: '2,500',
                      image: AppImages.coinsIcon,
                    ),
                    _buildShopItem(
                      price: '99',
                      coins: '10,000',
                      image: AppImages.coinsIcon,
                    ),
                  ],
                ),
              ),
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
      height: 65,
      width: 400,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppImages.goldenChamberFrame),
              fit: BoxFit.fill
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(image, width: 50, height: 45),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Rs. ',
                    style: GoogleFonts.cinzel(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    price,
                    style: GoogleFonts.cinzel(
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
          Transform.rotate(
            angle: 90 * 3.1415926535 / 180, // 90 degrees in radians
            child: Image.asset(
              AppImages.highlightValue,
              width: 60,
            ),
          ),
          // Coins Section
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                coins,
                style: GoogleFonts.cinzel(
                  color: AppTheme.borderGold,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'COINS',
                style: GoogleFonts.cinzel(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
