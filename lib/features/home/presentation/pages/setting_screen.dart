import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../login/presentation/widgets/shared_decorations.dart';
import '../../domain/entities/user_data_entity.dart';
import '../widgets/app_background.dart';

class SettingScreen extends StatefulWidget {
  final UserDataEntity userData;
  const SettingScreen({super.key, required this.userData});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSoundOn = true;
  bool isVibrateOn = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AdaptiveStatusBar(
      color: Theme.of(context).colorScheme.surface,
      child: AppBackground(
        animateContent: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(height: 20),
              // Header section
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Stack(
                  children: [
                    Center(
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.goldenStarLine,
                            width: 50,
                          ),
                          const GoldenTitle(
                            title: 'SETTINGS',
                            fontSize: 32,
                          ),
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
                    ),
                    Positioned(
                      right: 20,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Image.asset(AppImages.homeMenuIcon, width: 60),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Main Settings Box
              Container(
                padding: EdgeInsets.all(20),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: AppTheme.navyBlue,
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: AssetImage(AppImages.goldenOutline),
                    fit: BoxFit.fill
                  )
                ),
                child: Column(
                  spacing: 15,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Game Sound
                    _buildToggleRow(
                      leadingIcon: Icons.volume_down,
                      icon: AppImages.soundIcon,
                      title: 'GAME SOUND',
                      isActive: isSoundOn,
                      onLabel: 'ON',
                      offLabel: 'MUTE',
                      onIcon: Icons.volume_up,
                      offIcon: Icons.volume_off,
                      onToggle: (val) => setState(() => isSoundOn = val),
                    ),
                    // Vibrate
                    _buildToggleRow(
                      leadingIcon: Icons.vibration_sharp,
                      icon: AppImages.vibrateIcon,
                      title: 'VIBRATE',
                      isActive: isVibrateOn,
                      onLabel: 'ON',
                      offLabel: 'OFF',
                      onIcon: Icons.vibration,
                      offIcon: Icons.phone_android,
                      onToggle: (val) => setState(() => isVibrateOn = val),
                    ),
                    _buildNavigationTile(
                      image: AppImages.termsAndCondition,
                      title: 'TERMS AND CONDITIONS',
                      onTap: () {
                        // TODO: Add Navigation
                      },
                    ),
                    _buildNavigationTile(
                      image: AppImages.privacyPolicy,
                      title: 'PRIVACY POLICY',
                      onTap: () {
                        // TODO: Add Navigation
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    IconData? leadingIcon,
    required String icon,
    required String title,
    required bool isActive,
    required String onLabel,
    required String offLabel,
    required IconData onIcon,
    required IconData offIcon,
    required ValueChanged<bool> onToggle,
  }) {
    return SizedBox(
      width: 500,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.borderGold, width: 2),
            ),
            child: leadingIcon == null ? Image.asset(icon, width: 25, height: 25) : Icon(leadingIcon, color: AppTheme.borderGold, size: 25),
          ),
          Transform.rotate(
            angle: 90 * 3.1415926535 / 180, // 90 degrees in radians
            child: Image.asset(
              AppImages.highlightValue,
              width: 50,
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.cinzel(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 30,
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: AppTheme.borderGold)
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onToggle(true),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                        gradient: isActive
                            ? LinearGradient(
                          colors: [
                            Colors.amberAccent.shade100,
                            Colors.amber.shade50,
                            Colors.amberAccent.shade100,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(onIcon, color: isActive ? Colors.black : Colors.white38, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            onLabel,
                            style: GoogleFonts.cinzel(
                              color: isActive ? Colors.black : Colors.white38,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onToggle(false),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                        gradient: !isActive
                            ? LinearGradient(
                                colors: [
                                  Colors.amberAccent.shade100,
                                  Colors.amber.shade50,
                                  Colors.amberAccent.shade100,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(offIcon, color: !isActive ? Colors.black : Colors.white38, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            offLabel,
                            style: GoogleFonts.cinzel(
                              color: !isActive ? Colors.black : Colors.white38,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required String image,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 500,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: AppTheme.navyBlue,
            image: DecorationImage(
                image: AssetImage(AppImages.goldenChamberFrame),
                fit: BoxFit.fill
            )        ),
        child: Row(
          children: [
            Image.asset(image, width: 25, height: 25),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.cinzel(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Text(
              '|',
              style: TextStyle(color: AppTheme.borderGold, fontSize: 25, fontWeight: FontWeight.w200),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios, color: AppTheme.borderGold, size: 20),
          ],
        ),
      ),
    );
  }
}
