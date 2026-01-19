import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static Color onSurfaceVariantTextColor = const Color(0xFFFFD700); // Gold
  static Color onSurfaceTextColor = Colors.white;
  static Color hintTextColor = Colors.white70;
  static Color primaryColor = const Color(0xFFFFD700); // Gold
  static Color onPrimaryColor = Colors.black;
  static Color primaryContainerColor = const Color(0xFFFFE082); // Lighter Gold
  static Color surfaceColor = const Color(0xFF4A0000); // Dark Maroon/Red
  static Color backgroundColor = const Color(0xFF800000); // Deep Red

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: surfaceColor,
        onPrimary: onPrimaryColor,
        primaryContainer: primaryContainerColor,
        onPrimaryContainer: Colors.black,
        onSurfaceVariant: onSurfaceVariantTextColor,
        onSurface: onSurfaceTextColor,
        surface: surfaceColor,
        error: Colors.redAccent,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: TextTheme(
        displayLarge: const TextStyle(fontSize: 57, fontWeight: FontWeight.bold, color: Colors.white),
        displayMedium: const TextStyle(fontSize: 45, fontWeight: FontWeight.w600, color: Colors.white),
        displaySmall: const TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white),
        headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.white),
        headlineMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
        headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: onSurfaceTextColor),
        titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFFFFD700)), // Gold title
        titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70),
        bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: hintTextColor),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: onSurfaceVariantTextColor),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurfaceVariantTextColor),
        labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        labelSmall: TextStyle(fontSize: 11, color: Colors.grey[400]),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF4A0000),
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFFFFD700)),
        iconTheme: IconThemeData(color: Color(0xFFFFD700)),
      ),
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states){
            if (!states.contains(WidgetState.selected)) {
              return Colors.transparent;
            }
            return primaryColor;
          }),
          checkColor: const WidgetStatePropertyAll(Colors.black),
          side: BorderSide(color: primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          )
      ),
      dividerTheme: const DividerThemeData(
          color: Color(0xFFFFD700), // Gold dividers
          thickness: 1
      ),
      bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFF4A0000)
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(primaryColor),
              foregroundColor: WidgetStatePropertyAll(onPrimaryColor),
              textStyle: const WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.bold))
          )
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme; // Since the app has a specific game theme, dark/light might be similar
  }
}
