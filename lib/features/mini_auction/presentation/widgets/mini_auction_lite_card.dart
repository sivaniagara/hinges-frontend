import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../pages/mini_auction_screen.dart';

class MiniAuctionLiteCard extends StatelessWidget {
  final String image;
  final VoidCallback onTap;
  final String fee;
  final bool isLocked;
  final MiniAuctionItem miniAuctionItem;

  const MiniAuctionLiteCard({
    super.key,
    required this.image,
    required this.onTap,
    required this.fee,
    required this.isLocked,
    required this.miniAuctionItem,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return InkWell(
      onTap: isLocked ? null : onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            image,
            height: size.height * 0.38,
            width: size.width / 6,
            fit: BoxFit.fill,
          ),

          /// LOCK ICON
          if (isLocked)
            const Positioned(
              top: 10,
              right: 10,
              child: Icon(Icons.lock, color: Colors.red),
            ),

          /// INFO ICON
          Positioned(
            bottom: 0,
            right: 0,
            child: InfoIcon(
              isLocked: false,
              onTap: (){
                showClassicRoomDialog(context, miniAuctionItem);
              },

            ),
          ),

          /// ENTRY FEE
          Positioned(
            bottom: 28,
            child: Column(
              children: [
                Text(
                  'ENTRY FEE',
                  style: GoogleFonts.cinzel(
                    color: AppTheme.borderGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Image.asset(AppImages.coinMenuIcon, width: 15),
                    const SizedBox(width: 5),
                    Text(
                      '$fee COIN',
                      style: GoogleFonts.cinzel(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}