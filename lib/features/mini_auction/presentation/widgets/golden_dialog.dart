import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../pages/mini_auction_screen.dart';

/// 🔹 CALL THIS FUNCTION FROM YOUR BUTTON

/// 🔹 MAIN DIALOG
class GoldenDialog extends StatelessWidget {
  final MiniAuctionItem miniAuctionItem;
  const GoldenDialog({super.key, required this.miniAuctionItem});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🔸 GOLDEN FRAME CONTAINER
        Container(
          width: 500,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.goldenDialogFrame), // your generated frame
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),

              /// 🔹 TITLE
              Text(
                "${miniAuctionItem.name} ROOM",
                style: GoogleFonts.cinzel(
                  color: AppTheme.borderGold,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              /// 🔹 DECORATIVE LINE
              Image.asset(
                AppImages.highlightValue,
                width: 120,
              ),

              const SizedBox(height: 15),

              /// 🔹 ENTRY FEES
              _infoRow(
                title: "ENTRY FEES",
                value: "${miniAuctionItem.fee} COINS",
              ),

              const SizedBox(height: 10),

              /// 🔹 PRIZES
              _prizeRow(
                trophy: AppImages.firstPrize,
                title: "1ST PRIZE",
                value: "${miniAuctionItem.firstPrize} COINS",
              ),
              _prizeRow(
                trophy: AppImages.secondPrize,
                title: "2ND PRIZE",
                value: "${miniAuctionItem.secondPrize} COINS",
              ),
              _prizeRow(
                trophy: AppImages.thirdPrize,
                title: "3RD PRIZE",
                value: "${miniAuctionItem.thirdPrize} COINS",
              ),

              const SizedBox(height: 15),

              /// 🔹 NOTE
              Text(
                "NOTE: ONLY QUALIFIED USERS ARE\nELIGIBLE FOR PRIZE REWARDS",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),

        /// 🔴 CLOSE BUTTON (TOP RIGHT)
        Positioned(
          right: 8,
          top: 8,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.shade700,
                border: Border.all(
                  color: AppTheme.borderGold,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 🔹 ENTRY ROW
Widget _infoRow({
  required String title,
  required String value,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      SizedBox(
        width: 200,
        child: Text(
          title,
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(
        width: 200,
        child: Row(
          children: [
            Image.asset(AppImages.coinMenuIcon, width: 20),
            const SizedBox(width: 5),
            Text(
              value,
              style: GoogleFonts.cinzel(
                color: AppTheme.borderGold,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

/// 🔹 PRIZE ROW
Widget _prizeRow({
  required String trophy,
  required String title,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 200,
          child: Row(
            children: [
              Image.asset(trophy, width: 28),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.cinzel(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 200,
          child: Row(
            children: [
              Image.asset(AppImages.coinMenuIcon, width: 20),
              const SizedBox(width: 5),
              Text(
                value,
                style: GoogleFonts.cinzel(
                  color: AppTheme.borderGold,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}