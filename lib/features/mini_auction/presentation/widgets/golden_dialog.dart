import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_sounds.dart';
import '../../../../core/utils/audio_manager.dart';
import '../../../../core/utils/so_loud.dart';
import '../pages/mini_auction_screen.dart';

/// 🔹 CALL THIS FUNCTION FROM YOUR BUTTON

/// 🔹 MAIN DIALOG
class GoldenDialog extends StatelessWidget {
  final MiniAuctionItem miniAuctionItem;
  const GoldenDialog({super.key, required this.miniAuctionItem});

  String _getDifficulty() {
    switch (miniAuctionItem.miniAuctionLiteModeEnum) {
      case MiniAuctionLiteModeEnum.classic: return "BEGINNER";
      case MiniAuctionLiteModeEnum.premium: return "INTERMEDIATE";
      case MiniAuctionLiteModeEnum.elite: return "ADVANCED";
      case MiniAuctionLiteModeEnum.royal: return "EXPERT";
    }
  }

  String _getStrategyLevel() {
    switch (miniAuctionItem.miniAuctionLiteModeEnum) {
      case MiniAuctionLiteModeEnum.classic: return "BALANCED";
      case MiniAuctionLiteModeEnum.premium: return "AGGRESSIVE";
      case MiniAuctionLiteModeEnum.elite: return "STRATEGIC";
      case MiniAuctionLiteModeEnum.royal: return "PROFESSIONAL";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// 🔸 GOLDEN FRAME CONTAINER
        Container(
          width: 420, // was 550
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18), // was 20 / 30
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.goldenDialogFrame), // your generated frame
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6), // was 10

              /// 🔹 TITLE
              Text(
                "${miniAuctionItem.name.toUpperCase()} ROOM",
                style: GoogleFonts.rajdhani(
                  color: AppTheme.borderGold,
                  fontSize: 20, // was 26
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),

              const SizedBox(height: 3), // was 5

              /// 🔹 DECORATIVE LINE
              Image.asset(
                AppImages.goldenCrownLine,
                width: 150, // was 200
              ),

              const SizedBox(height: 10), // was 20

              /// 🔹 ENTRY FEES
              _buildRow(
                title: "ENTRY FEES",
                value: _coinValue("${miniAuctionItem.fee} COINS"),
              ),

              /// 🔹 PRIZES
              _buildRow(
                leading: Image.asset(AppImages.firstPrize, width: 22), // was 28
                title: "1ST PRIZE",
                value: _coinValue("${miniAuctionItem.firstPrize} COINS"),
              ),
              _buildRow(
                leading: Image.asset(AppImages.secondPrize, width: 22),
                title: "2ND PRIZE",
                value: _coinValue("${miniAuctionItem.secondPrize} COINS"),
              ),
              _buildRow(
                leading: Image.asset(AppImages.thirdPrize, width: 22),
                title: "3RD PRIZE",
                value: _coinValue("${miniAuctionItem.thirdPrize} COINS"),
              ),

              /// 🔹 DIFFICULTY
              _buildRow(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) => const Icon(Icons.star, color: AppTheme.borderGold, size: 14)), // was 18
                ),
                title: "DIFFICULTY",
                value: Text(
                  _getDifficulty(),
                  style: GoogleFonts.rajdhani(
                    color: Colors.white,
                    fontSize: 13, // was 16
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /// 🔹 STRATEGY LEVEL
              _buildRow(
                title: "STRATEGY LEVEL",
                value: Text(
                  _getStrategyLevel(),
                  style: GoogleFonts.rajdhani(
                    color: Colors.white,
                    fontSize: 13, // was 16
                    fontWeight: FontWeight.bold,
                  ),
                ),
                showDivider: false, // last row before note — no trailing divider
              ),

              const SizedBox(height: 10), // was 15

              /// 🔹 NOTE
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "NOTE: ",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 10, // was 12
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "ONLY QUALIFIED USERS ARE ELIGIBLE FOR PRIZE REWARDS",
                      style: GoogleFonts.roboto(
                        color: AppTheme.borderGold,
                        fontSize: 10, // was 12
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10), // was 15
            ],
          ),
        ),

        /// 🔴 CLOSE BUTTON (TOP RIGHT)
        Positioned(
          right: 0, // was -10
          top: 10, // was -10
          child: GestureDetector(
            onTap: () {
              playVibrateOnly(duration: 10);
              Navigator.pop(context);
            },
            child: Image.asset(
              AppImages.cancel,
              width: 32, // was 40
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow({
    Widget? leading,
    required String title,
    required Widget value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 4), // was 40 / 6
          child: Row(
            children: [
              if (leading != null) ...[
                leading,
                const SizedBox(width: 8), // was 12
              ],
              Text(
                title,
                style: GoogleFonts.rajdhani(
                  color: Colors.white,
                  fontSize: 13, // was 16
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              value,
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26), // was 40
            child: Divider(
              color: AppTheme.borderGold.withOpacity(0.3),
              thickness: 1,
              height: 1,
            ),
          ),
      ],
    );
  }

  Widget _coinValue(String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AppImages.coinMenuIcon, width: 18), // was 24
        const SizedBox(width: 6), // was 8
        Text(
          value,
          style: GoogleFonts.rajdhani(
            color: AppTheme.borderGold,
            fontSize: 13, // was 16
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}