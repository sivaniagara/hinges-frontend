import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/widgets/gradient_text.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../login/presentation/widgets/mandala_background.dart';
import '../../../login/presentation/widgets/shared_decorations.dart';
import '../../bloc/ad_bloc.dart';
import '../../bloc/ad_event.dart';

class AdPage extends StatefulWidget {
  const AdPage({super.key});

  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  @override
  void initState() {
    super.initState();

    // Force Landscape for the Ad Break screen to match the design
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Start showing the ad after a brief delay to let the UI render
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.read<AdBloc>().add(ShowInterstitialAd(
          onAdClosed: () {
            if (mounted) {
              // Restore orientations if needed, though usually handled by other pages
              context.go('/home');
            }
          },
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MandalaBackground(
        animateContent: false,
        child: Stack(
          children: [
            /// 🖼️ Golden Frame / Border
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.primaryGold.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            /// ✨ Corner Accents (Optional, if assets exist, or just use Container decoration)
            _buildCornerAccents(),

            /// 🌟 Center Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 🏆 INDIAN BIDDING LEAGUE LOGO
                  Image.asset(
                    AppImages.indianBiddingLeague,
                    width: 100,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 10),
                  Image.asset(AppImages.headerGoldenCrown, width: 150, height: 20),
                  /// 📢 AD BREAK TEXT
                  GradientText(
                    title: "AD BREAK",
                    fontSize: 40,
                    textAlign: TextAlign.center,
                    colors: const [
                      Color(0xFFFFD700), // Bright Gold
                      Color(0xFFEFCD83), // Soft Gold
                      Color(0xFFD4AF37), // Darker Gold
                    ],
                  ),

                  const SizedBox(height: 5),

                  /// 🟡 Divider Line
                  Image.asset(AppImages.goldenCrownLine, width: 200, height: 20),


                  const SizedBox(height: 10),

                  /// ⏳ PLEASE WAIT...
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "PLEASE WAIT...",
                        style: GoogleFonts.rajdhani(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🎬 VIDEO PLAYER ICON IN GLOWING CIRCLE
                  _buildGlowingVideoIcon(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlowingVideoIcon() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppTheme.primaryGold.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        border: Border.all(
          color: AppTheme.primaryGold,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGold.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppTheme.primaryGold.withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const FaIcon(
        FontAwesomeIcons.clapperboard,
        color: AppTheme.primaryGold,
        size: 25,
      ),
    );
  }

  Widget _buildCornerAccents() {
    return Stack(
      children: [
        Positioned(
          top: 8,
          left: 8,
          child: _CornerDecoration(quarterTurns: 0),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: _CornerDecoration(quarterTurns: 1),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: _CornerDecoration(quarterTurns: 2),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          child: _CornerDecoration(quarterTurns: 3),
        ),
      ],
    );
  }
}

class _CornerDecoration extends StatelessWidget {
  final int quarterTurns;
  const _CornerDecoration({required this.quarterTurns});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.primaryGold, width: 3),
            left: BorderSide(color: AppTheme.primaryGold, width: 3),
          ),
        ),
      ),
    );
  }
}
