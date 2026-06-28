import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';

class IconWithCircularBorder extends StatelessWidget {
  final String image;
  final String settingName;
  const IconWithCircularBorder({super.key, required this.image, required this.settingName});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Image.asset(
          image,
          width: 50, // keep icon size consistent
        ),
        const SizedBox(height: 4),
        Text(
          settingName,
          style: GoogleFonts.rajdhani(
            color: AppTheme.borderGold,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
