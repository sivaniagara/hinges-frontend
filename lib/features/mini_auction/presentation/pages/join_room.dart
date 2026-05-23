import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/presentation/widgets/back_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../game/presentation/pages/game_screen.dart';
import '../../../home/presentation/widgets/app_background.dart';
import 'mini_auction_screen.dart';

class JoinRoom extends StatefulWidget {
  final MiniAuctionLiteMode mode;
  const JoinRoom({super.key, required this.mode});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  TextEditingController roomCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: AppBackground(
        animateContent: false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SizedBox(
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      CrownTitle(text: 'JOIN ROOM'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.goldenStarLine,
                            width: 50,
                          ),
                          Text('ENTER THE ROOM CODE', style: GoogleFonts.cinzel(textStyle: TextStyle(color: AppTheme.borderGold, fontSize: 15, fontWeight: FontWeight.bold)),),
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
                      SizedBox(
                        width: 400,
                        child: TextFormField(
                          controller: roomCodeController,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cinzel(textStyle: TextStyle(fontSize: 14, color: AppTheme.borderGold, fontWeight: FontWeight.bold)),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'ENTER ROOM CODE'
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          context.go('/game', extra: {
                            "mode": widget.mode,
                            "matchType": MatchTypeEnum.roomMatch,
                            "roomCode": roomCodeController.text.trim(),
                          });
                        },
                        child: Container(
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
                            Text('  ${widget.mode.miniAuctionItem.name} ROOM  ', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
                          ],
                        ),
                      ),
                    ],
                  ),
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
