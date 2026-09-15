import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/so_loud.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../login/presentation/widgets/shared_decorations.dart';
import '../bloc/game_bloc.dart';

class ExitDialog extends StatelessWidget {
  final String title;
  final VoidCallback? onTapYes;

  const ExitDialog({
    super.key,
    this.title = 'ARE YOU SURE YOU WANT TO QUIT',
    this.onTapYes,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// 🔸 GOLDEN FRAME CONTAINER
        SizedBox(
          width: 500,
          height: 200,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Navy fill, sized slightly inside the frame's gold line
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(6), // tune to frame's stroke thickness
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.navyBlue,
                      borderRadius: BorderRadius.circular(28), // tune to frame's corner radius
                    ),
                  ),
                ),
              ),
              // Frame image drawn on top, untouched
              Positioned.fill(
                child: Image.asset(
                  AppImages.dialogFrame,
                  fit: BoxFit.fill,
                ),
              ),
              // Content, padded inward
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                height: double.infinity,
                child: Column(
                  spacing: 20,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GoldenTitle(title: title, fontSize: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (onTapYes != null) {
                              onTapYes!();
                              return;
                            }
                            final homeState = context.read<HomeBloc>().state;
                            final gameState = context.read<GameBloc>().state;
                            if (homeState is HomeLoaded && gameState is GameLoaded) {
                              context.read<GameBloc>().add(
                                ExitMatch(
                                  userId: homeState.userData.userId,
                                  matchId: gameState.gameData.matchId,
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              // NOTE: removed `image: DecorationImage(dialogFrame)` here.
                              // That was the big outer dialog frame asset stretched into
                              // a 150x50 button — it was both fighting with `color` in the
                              // same BoxDecoration (same bug as the outer frame) AND being
                              // squashed/distorted since it's not a button-shaped asset.
                              // Using a plain colored rounded rect + gold border instead.
                              // If you have a dedicated small "button frame" asset, swap
                              // this back to the Stack pattern (color layer + image layer).
                              color: const Color(0xff000F3A),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppTheme.borderGold,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'YES',
                                style: GoogleFonts.rajdhani(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              // Same fix as YES button above.
                              color: const Color(0xff370000),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppTheme.borderGold,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'NO',
                                style: GoogleFonts.rajdhani(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// 🔴 CLOSE BUTTON (TOP RIGHT)
        Positioned(
          right: 8,
          top: 8,
          child: GestureDetector(
            onTap: () {
              playVibrateOnly(duration: 10);
              Navigator.pop(context);
            },
            child: Image.asset(
              AppImages.cancel,
              width: 40,
            ),
          ),
        ),
      ],
    );
  }
}