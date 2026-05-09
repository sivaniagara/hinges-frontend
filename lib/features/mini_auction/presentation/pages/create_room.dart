import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/presentation/widgets/back_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';

import '../../../../core/utils/dialog_box_and_bottom_sheet_utils.dart';
import '../../../game/presentation/bloc/game_bloc.dart';
import '../../../home/presentation/widgets/app_background.dart';
import 'mini_auction_screen.dart';

class CreateRoom extends StatelessWidget {
  final MiniAuctionLiteMode mode;
  const CreateRoom({super.key, required this.mode});

  /// 📋 COPY FUNCTION
  void copyRoomCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));

    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _SimpleCopyToast(
        onClose: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
  /// 📲 WHATSAPP SHARE
  Future<void> shareViaWhatsApp(String code) async {
    final message = Uri.encodeComponent(
      "🎮 Join my room!\nRoom Code: $code",
    );

    final url = Uri.parse("https://wa.me/?text=$message");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {

        /// 🔄 LOADING
        if (state is RoomCodeLoading) {
          showLoadingDialog(context, message: "Generating Room Code...");
        }

        /// ✅ SUCCESS
        else if (state is RoomCodeLoaded) {
          Navigator.pop(context);
        }

        /// ❌ ERROR
        else if (state is RoomCodeError) {
          Navigator.pop(context);

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return Dialog(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.amber),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      const Icon(Icons.error_outline, color: Colors.red, size: 40),
                      const SizedBox(height: 15),

                      Text(
                        "FAILED TO GENERATE CODE",
                        style: GoogleFonts.cinzel(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        state.message ?? "Something went wrong",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          /// 🔁 RETRY
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<GameBloc>().add(GetRoomCode());
                            },
                            child: const Text("RETRY"),
                          ),

                          /// ❌ CANCEL
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("CANCEL"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      },

      child: AdaptiveStatusBar(
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

                      /// ROOM CARD
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

                            /// CODE DISPLAY
                            Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: AppTheme.borderGold),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: BlocBuilder<GameBloc, GameState>(
                                builder: (context, state) {
                                  if (state is RoomCodeLoading) {
                                    return const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppTheme.borderGold,
                                      ),
                                    );
                                  } else if (state is RoomCodeLoaded) {
                                    return Text(
                                      state.roomCode,
                                      style: GoogleFonts.cinzel(
                                        textStyle: const TextStyle(
                                          color: AppTheme.borderGold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    );
                                  } else if (state is RoomCodeError) {
                                    return const Icon(Icons.error,
                                        color: Colors.red);
                                  }
                                  return Text(
                                    '......',
                                    style: GoogleFonts.cinzel(
                                      textStyle: const TextStyle(
                                        color: AppTheme.borderGold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            /// COPY BUTTON
                            BlocBuilder<GameBloc, GameState>(
                              builder: (context, state) {
                                String? code;
                                if (state is RoomCodeLoaded) {
                                  code = state.roomCode;
                                }

                                return GestureDetector(
                                  onTap: code == null
                                      ? null
                                      : () => copyRoomCode(context, code!),
                                  child: Container(
                                    width: 150,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: AppTheme.borderGold),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        const Icon(Icons.copy,
                                            color: AppTheme.borderGold),
                                        Text(
                                          'COPY CODE',
                                          style: GoogleFonts.cinzel(
                                            textStyle: const TextStyle(
                                              color: AppTheme.borderGold,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      /// WHATSAPP SHARE
                      BlocBuilder<GameBloc, GameState>(
                        builder: (context, state) {
                          String? code;
                          if (state is RoomCodeLoaded) {
                            code = state.roomCode;
                          }

                          return GestureDetector(
                            onTap: code == null
                                ? null
                                : () => shareViaWhatsApp(code!),
                            child: Container(
                              width: 400,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: AppTheme.borderGold),
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.black,
                                    Color(0xff082E01),
                                    Colors.black,
                                  ],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                spacing: 20,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(AppImages.whatsapp, width: 30),
                                  Text(
                                    'SHARE CODE VIA WHATSAPP',
                                    style: GoogleFonts.cinzel(
                                      textStyle: const TextStyle(
                                        color: AppTheme.borderGold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      /// ENTER ROOM
                      Container(
                        width: 400,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: AppTheme.borderGold),
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              AppTheme.cardBlue,
                              Colors.black,
                            ],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          spacing: 20,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AppImages.enterRoomIcon, width: 30),
                            Text(
                              'ENTER THE ROOM',
                              style: GoogleFonts.cinzel(
                                textStyle: const TextStyle(
                                  color: AppTheme.borderGold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      /// MODE CARD
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
                            Text(
                              '  ${mode.miniAuctionItem.name} ROOM  ',
                              style: GoogleFonts.cinzel(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Positioned(
                  top: 0,
                  right: 0,
                  child: BackIcon(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleCopyToast extends StatefulWidget {
  final VoidCallback onClose;

  const _SimpleCopyToast({required this.onClose});

  @override
  State<_SimpleCopyToast> createState() => _SimpleCopyToastState();
}

class _SimpleCopyToastState extends State<_SimpleCopyToast> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80, // 👈 small top popup (you can adjust)
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.amber,
                width: 1,
              ),
            ),
            child: const Text(
              "CODE COPIED",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}