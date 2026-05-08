import 'dart:math' as math;

import 'package:flutter/material.dart' hide Title;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/presentation/widgets/back_icon.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/widgets/app_background.dart';
import 'mini_auction_screen.dart';


class PlayWithFriends extends StatelessWidget {
  final MiniAuctionLiteMode mode;
  const PlayWithFriends({super.key, required this.mode});

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
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CrownTitle(text: 'PLAY WITH FRIENDS'),
                    Container(
                      width: size.width * 0.4,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(AppImages.goldenFrame),
                        ),
                      ),
                      child: Text(
                        'MINI AUCTION LITE',
                        style: GoogleFonts.cinzel(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.borderGold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.goldenStarLine,
                          width: 50,
                        ),
                        Text('  ${mode.miniAuctionItem.name} ROOM  ', style: GoogleFonts.cinzel(textStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      children: [
                        GameCard(
                          image: AppImages.createRoom,
                          onTap: () {
                            context.push('/createRoom', extra: mode);
                          },
                          size: size,
                        ),
                        const SizedBox(width: 20),
                        GameCard(
                          image: AppImages.joinRoom,
                          onTap: () {
                            context.push('/joinRoom', extra: mode);
                          },
                          size: size,
                        ),
                      ],
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