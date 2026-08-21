import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
    this.title = 'ARE YOU SURE YOU WANT TO EXIT',
    this.onTapYes,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🔸 GOLDEN FRAME CONTAINER
        Container(
          width: 500,
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.dialogFrame), // your generated frame
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GoldenTitle(title: title, fontSize: 18,),
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
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage(
                                AppImages.dialogFrame,
                              ),
                              fit: BoxFit.fill
                          ),
                          color: Color(0xff000F3A)
                      ),
                      child: Center(
                        child: Text(
                            'YES',
                            style: GoogleFonts.rajdhani(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            )
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage(
                                AppImages.dialogFrame,
                              ),
                              fit: BoxFit.fill
                          ),
                          color: Color(0xff370000)
                      ),
                      child: Center(
                        child: Text(
                            'NO',
                            style: GoogleFonts.rajdhani(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            )
                        ),
                      ),
                    ),
                  ),
                ],
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