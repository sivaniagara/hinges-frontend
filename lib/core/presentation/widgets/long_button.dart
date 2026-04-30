import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/theme/app_theme.dart';

class LongButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final bool outlined;
  IconData? prefixIcon;
  LongButton({super.key, required this.title, required this.onPressed, required this.outlined, this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        color: AppTheme.cardBlue,
        borderRadius: BorderRadius.circular(10),
        border: outlined ? Border.all(color: AppTheme.borderGold, width: 1) : null
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            if(prefixIcon != null)
              FaIcon(prefixIcon, color: AppTheme.borderGold,),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFFFDFFAF),
                  AppTheme.borderGold,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 6),
                      blurRadius: 8,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
