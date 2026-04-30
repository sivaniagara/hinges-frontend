import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
          colors: [
            Color(0xFFFDFFAF),
            AppTheme.borderGold,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "By continuing, you agree to our ",
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    color: AppTheme.borderGold
                  ),
                ),

                /// Terms
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: () => _openUrl("https://your-terms-url.com"),
                    child: Text(
                      "Terms",
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: AppTheme.borderGold
                      ),
                    ),
                  ),
                ),

                TextSpan(
                    text: " & ",
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: AppTheme.borderGold
                  ),
                ),

                /// Privacy Policy
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: () => _openUrl("https://your-privacy-url.com"),
                    child: Text(
                      "Privacy Policy",
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: AppTheme.borderGold
                      ),
                    ),
                  ),
                ),

                const TextSpan(text: "."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}