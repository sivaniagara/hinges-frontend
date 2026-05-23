import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../login/presentation/widgets/shared_decorations.dart';
import '../widgets/app_background.dart';

class RuleBookScreen extends StatelessWidget {
  const RuleBookScreen({super.key});

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

              /// 🔹 HEADER
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Stack(
                  children: [
                    Center(
                      child: Row(
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
                        onTap: () => context.pop(),
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
                    width: size.width * 0.8,
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 2.6,
                      children: [
                        _buildRuleCard(
                          title1: "MINI AUCTION",
                          title2: "LITE",
                          isLocked: false,
                          onTap: (){
                            context.push('/ruleBook/miniAuctionLiteRuleBook');
                          }
                        ),
                        _buildRuleCard(
                          title1: "MINI AUCTION",
                          title2: "PRO",
                          isLocked: true,
                        ),
                        _buildRuleCard(
                          title1: "MEGA AUCTION",
                          title2: "LITE",
                          isLocked: true,
                        ),
                        _buildRuleCard(
                          title1: "MEGA AUCTION",
                          title2: "PRO",
                          isLocked: true,
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

  /// 🔹 RULE CARD WIDGET
  Widget _buildRuleCard({
    required String title1,
    required String title2,
    required bool isLocked,
    void Function()? onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.goldenChamberFrame),
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
                  Text(
                    title1,
                    style: GoogleFonts.cinzel(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title2,
                    style: GoogleFonts.cinzel(
                      color: AppTheme.borderGold,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "RULE BOOK",
                    style: GoogleFonts.cinzel(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔹 LOCK ICON
            if (isLocked)
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
    );
  }
}