import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  /// 🎨 Core Colors (Matched to your UI)
  static const Color primaryGold = Color(0xFFD4AF37); // Rich gold
  static const Color darkBlue = Color(0xFF0A1F44); // Main background
  static const Color navyBlue = Color(0xFF08142E); // Deep layer
  static const Color cardBlue = Color(0xFF102A5C); // Cards / buttons
  static const Color borderGold = Color(0xFFFFD700);

  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,

      /// 🌈 Color Scheme
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: primaryGold,
        onPrimary: Colors.black,
        secondary: cardBlue,
        onSecondary: white,
        surface: navyBlue,
        onSurface: white,
        error: Colors.redAccent,
        onError: white,
      ),

      scaffoldBackgroundColor: darkBlue,

      /// 🧾 Text Theme (Luxury feel)
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 52,
          fontWeight: FontWeight.bold,
          color: primaryGold,
          letterSpacing: 1.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: white,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryGold,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: white70,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primaryGold,
        ),
      ),

      /// 📱 AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: navyBlue,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryGold,
        ),
        iconTheme: IconThemeData(color: primaryGold),
      ),

      /// 🔘 Buttons (Styled like your UI)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cardBlue,
          foregroundColor: primaryGold,
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: borderGold, width: 1.2),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      /// 🔲 Card Theme
      cardTheme: CardThemeData(
        color: cardBlue,
        elevation: 6,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderGold, width: 0.8),
        ),
      ),

      /// ☑ Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryGold;
          }
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(Colors.black),
        side: const BorderSide(color: primaryGold, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),

      /// ➖ Divider
      dividerTheme: const DividerThemeData(
        color: borderGold,
        thickness: 0.6,
      ),

      /// 📦 Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: navyBlue,
      ),

      /// 💡 Input Fields (Optional but useful)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBlue,
        hintStyle: const TextStyle(color: white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderGold),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderGold, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGold, width: 1.5),
        ),
      ),
    );
  }
}