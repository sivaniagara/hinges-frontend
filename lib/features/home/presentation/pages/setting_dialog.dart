import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/presentation/widgets/cancel_header.dart';

import '../../../../core/utils/app_images.dart';

class SettingDialog extends StatelessWidget {
  const SettingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      alignment: AlignmentGeometry.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xFF800000), // Maroon Background
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Header Row
            CancelHeader(),
            IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(AppImages.redTag))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    spacing: 10,
                    children: [
                      Image.asset(AppImages.settingsMenuIcon, width: 25,),
                      Text(
                        'SETTINGS',
                        style: GoogleFonts.oxanium(
                          textStyle: TextStyle(
                            fontSize: 16,
                            foreground: Paint()
                              ..color = Colors.yellow
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 0.8,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),            // Main Content
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSettingSection(context, image: AppImages.soundIcon, settingName: 'GAME SOUND'),
                  _buildSettingSection(context, image: AppImages.vibrateIcon, settingName: 'VIBRATE'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSection(BuildContext context, {required String image, required String settingName,}) {
    return Column(
      children: [
        Image.asset(
            image,
          width: 60,
        ),
        Text(
          settingName,
          style: GoogleFonts.oxanium(
            textStyle: TextStyle(
              fontSize: 12,
              foreground: Paint()
                ..color = Colors.yellow
                ..style = PaintingStyle.stroke
                ..strokeWidth = 0.8,
            ),
          ),
        )
      ],
    );
  }
}
