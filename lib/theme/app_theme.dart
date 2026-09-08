import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B26);
  static const Color surfaceRaised = Color(0xFF1E2532);
  static const Color border = Color(0xFF262E3D);
  static const Color accentGold = Color(0xFFE8A33D);
  
  static const Color gainGreen = Color(0xFF2FB88A);
  static const Color gainBgTint = Color(0xFF16342A);
  
  static const Color lossRed = Color(0xFFE85D5D);
  static const Color lossBgTint = Color(0xFF35201F);
  
  static const Color textPrimary = Color(0xFFEDEFF3);
  static const Color textMuted = Color(0xFF7C8494);
  static const Color textFaint = Color(0xFF4C5566);

  // Border Radius Constants
  static const double cardRadius = 14.0;
  static const double pillRadius = 24.0;

  // Text Styles
  static TextStyle headingStyle({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.bold,
    Color color = textPrimary,
  }) {
    return GoogleFonts.sora(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle bodyStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = textPrimary,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle monoStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
    Color color = textPrimary,
  }) {
    return GoogleFonts.ibmPlexMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: accentGold,
      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        surface: surface,
        onSurface: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accentGold,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: const BorderSide(color: border, width: 1),
        ),
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceRaised,
        selectedColor: accentGold,
        disabledColor: surface,
        secondarySelectedColor: accentGold,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        labelStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          color: background,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(pillRadius),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
    );
  }
}
