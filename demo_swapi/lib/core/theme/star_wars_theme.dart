import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demo_swapi/core/theme/app_colors.dart';

class StarWarsTheme {
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.forceYellow,
      secondary: AppColors.forceYellow,
      surface: AppColors.cardBackground,
      error: AppColors.errorRed,
      onPrimary: AppColors.spaceBlack,
      onSecondary: AppColors.spaceBlack,
      onSurface: AppColors.primaryText,
      onError: AppColors.primaryText,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.spaceBlack,
      brightness: Brightness.dark,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.forceYellow,
          letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.forceYellow,
          letterSpacing: 1.5,
        ),
        displaySmall: GoogleFonts.orbitron(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.forceYellow,
          letterSpacing: 1,
        ),
        headlineLarge: GoogleFonts.orbitron(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryText,
          letterSpacing: 1,
        ),
        headlineMedium: GoogleFonts.orbitron(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryText),
        titleLarge: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryText),
        titleMedium: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primaryText),
        bodyLarge: GoogleFonts.roboto(fontSize: 16, color: AppColors.primaryText),
        bodyMedium: GoogleFonts.roboto(fontSize: 14, color: AppColors.primaryText),
        bodySmall: GoogleFonts.roboto(fontSize: 12, color: AppColors.secondaryText),
        labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primaryText),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.spaceBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.forceYellow,
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: AppColors.forceYellow),
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderColor, width: 1),
        ),
        shadowColor: AppColors.forceYellow.withValues(alpha: 0.3),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.forceYellow, width: 2),
        ),
        hintStyle: TextStyle(color: AppColors.secondaryText),
        labelStyle: TextStyle(color: AppColors.secondaryText),
        prefixIconColor: AppColors.forceYellow,
        suffixIconColor: AppColors.forceYellow,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forceYellow,
          foregroundColor: AppColors.spaceBlack,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      listTileTheme: ListTileThemeData(
        tileColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textColor: AppColors.primaryText,
        iconColor: AppColors.forceYellow,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.forceYellow),
      iconTheme: const IconThemeData(color: AppColors.forceYellow, size: 24),
    );
  }

  static BoxShadow get glowShadow =>
      BoxShadow(color: AppColors.forceYellow.withValues(alpha: 0.5), blurRadius: 12, spreadRadius: 2);

  static BoxShadow get cardShadow =>
      BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 8, offset: const Offset(0, 4));
}
