import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/so_loud.dart';
import '../pages/home_screen.dart';

class AuctionInfoDialog extends StatelessWidget {
  final AuctionModeEnum mode;

  const AuctionInfoDialog({super.key, required this.mode});

  String _getTitle() {
    switch (mode) {
      case AuctionModeEnum.miniAuctionLite: return "MINI AUCTION LITE";
      case AuctionModeEnum.miniAuctionPro: return "MINI AUCTION PRO";
      case AuctionModeEnum.megaAuctionLite: return "MEGA AUCTION LITE";
      case AuctionModeEnum.megaAuctionPro: return "MEGA AUCTION PRO";
    }
  }

  String _getPlayers() {
    return (mode == AuctionModeEnum.miniAuctionLite || mode == AuctionModeEnum.megaAuctionLite) ? "5" : "10";
  }

  String _getAuctionType() {
    return (mode == AuctionModeEnum.miniAuctionLite || mode == AuctionModeEnum.miniAuctionPro)
        ? "PARTIAL SQUAD AUCTION"
        : "FULL SQUAD AUCTION";
  }

  String _getDuration() {
    switch (mode) {
      case AuctionModeEnum.miniAuctionLite: return "~8–12 MINUTES";
      case AuctionModeEnum.miniAuctionPro: return "~16–20 MINUTES";
      case AuctionModeEnum.megaAuctionLite: return "~20–25 MINUTES";
      case AuctionModeEnum.megaAuctionPro: return "~30–35 MINUTES";
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
              image: AssetImage(AppImages.goldenDialogFrame),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6), // was 10

              /// 🔹 TITLE
              Text(
                _getTitle(),
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

              const SizedBox(height: 12), // was 25

              _buildInfoRow("PLAYERS", _getPlayers()),
              _buildInfoRow("AUCTION TYPE", _getAuctionType()),
              _buildInfoRow("AUCTION ROUNDS", "5"),
              _buildInfoRow("AUCTION DURATION", _getDuration(), showDivider: false),

              const SizedBox(height: 6), // was 10
            ],
          ),
        ),

        /// 🔴 CLOSE BUTTON (TOP RIGHT)
        Positioned(
          right: 0, // was -10
          top: 10, // was -10
          child: GestureDetector(
            onTap: () {
              playTap();
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

  Widget _buildInfoRow(String label, String value, {bool showDivider = true}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 7), // was 40 / 12
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  label,
                  style: GoogleFonts.rajdhani(
                    color: Colors.white,
                    fontSize: 13, // was 16
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Transform.rotate(
                angle: 45 * 3.14159 / 180,
                child: Container(
                  width: 5, // was 6
                  height: 5, // was 6
                  color: AppTheme.borderGold,
                ),
              ),
              const SizedBox(width: 20), // was 30
              Expanded(
                flex: 7,
                child: Text(
                  value,
                  style: GoogleFonts.rajdhani(
                    color: AppTheme.borderGold,
                    fontSize: 13, // was 16
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
}