import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/so_loud.dart';

class InsufficientCoinsDialog extends StatelessWidget {
  const InsufficientCoinsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 380,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        decoration: BoxDecoration(
          color: AppTheme.navyBlue,
          image: const DecorationImage(
            image: AssetImage(AppImages.goldenDialogFrame),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔹 EXCLAMATION ICON
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.borderGold, width: 3),
              ),
              child: const Center(
                child: Icon(
                  Icons.priority_high_rounded,
                  color: AppTheme.borderGold,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// 🔹 MESSAGE
            Text(
              "You don't have enough coins\nto enter this auction room",
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),

            /// 🔹 OK BUTTON
            GestureDetector(
              onTap: () {
                playVibrateOnly(duration: 10);
                Navigator.pop(context);
              },
              child: Container(
                width: 140,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  "OK",
                  style: GoogleFonts.rajdhani(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
