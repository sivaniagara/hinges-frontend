import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/presentation/widgets/back_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../home/presentation/widgets/app_background.dart';
import 'mini_auction_screen.dart';

class CreateRoom extends StatelessWidget {
  final MiniAuctionLiteMode mode;
  const CreateRoom({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: AppBackground(
        animateContent: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CrownTitle(text: 'CREATE ROOM'),
                    Container(
                      width: 400,
                      height: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(AppImages.roomCodeCard),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 150,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: AppTheme.borderGold),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            alignment: Alignment.center,
                            child: Text('123456', style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontWeight: FontWeight.bold, fontSize: 20),))
                          ),
                          Container(
                            width: 150,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: AppTheme.borderGold),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.copy, color: AppTheme.borderGold,),
                                Text('COPY CODE', style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontWeight: FontWeight.bold, fontSize: 13),))
                              ],
                            )
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: 400,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: AppTheme.borderGold),
                            borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Color(0xff082E01),
                              Colors.black,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          spacing: 20,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AppImages.whatsapp, width: 30,),
                            Text('SHARE CODE VIA WHATSAPP', style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontWeight: FontWeight.bold, fontSize: 16),))
                          ],
                        )
                    ),
                    Container(
                        width: 400,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: AppTheme.borderGold),
                            borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              AppTheme.cardBlue,
                              Colors.black,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          spacing: 20,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AppImages.enterRoomIcon, width: 30,),
                            Text('ENTER THE ROOM', style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontWeight: FontWeight.bold, fontSize: 16),))
                          ],
                        )
                    ),
                    Container(
                      width: size.width * 0.4,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(AppImages.goldenFrame),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'MINI AUCTION LITE',
                            style: GoogleFonts.cinzel(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.borderGold,
                            ),
                          ),
                          Text('  ${mode.miniAuctionItem.name} ROOM  ', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: BackIcon(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
