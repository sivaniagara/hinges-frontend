import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class IconWithCircularBorder extends StatelessWidget {
  final String image;
  final String settingName;
  const IconWithCircularBorder({super.key, required this.image, required this.settingName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6), // important for spacing
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.borderGold, // ✅ golden border
              width: 0.8, // slightly thicker looks premium
            ),
          ),
          child: Image.asset(
            image,
            width: 30, // keep icon size consistent
          ),
        ),
        const SizedBox(height: 4),
        Text(
          settingName,
          style: GoogleFonts.cinzel(
            color: AppTheme.borderGold,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
