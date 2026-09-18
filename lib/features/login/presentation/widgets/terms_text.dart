import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/network/http_service_impl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../utils/login_urls.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  Future<void> _openUrl(String path) async {
    try {
      final String fullUrl;
      if (path.startsWith('http://') || path.startsWith('https://')) {
        fullUrl = path;
      } else {
        final String baseUrl = HttpServiceImpl.ipAddress.endsWith('/')
            ? HttpServiceImpl.ipAddress.substring(0, HttpServiceImpl.ipAddress.length - 1)
            : HttpServiceImpl.ipAddress;
        final String formattedPath = path.startsWith('/') ? path : '/$path';
        fullUrl = '$baseUrl$formattedPath';
      }
      final Uri uri = Uri.parse(fullUrl);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint('Could not launch $fullUrl');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
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
                    onTap: () {
                      _openUrl(LoginUrls.termsAndConditions);
                    },
                    child: Text(
                      "Terms of Service",
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
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
                    onTap: () {
                      _openUrl(LoginUrls.privacyPolicy);
                    },
                    child: Text(
                      "Privacy Policy",
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
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