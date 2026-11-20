import 'package:flutter/material.dart';

/// SMART KJA Color Palette defined in DESIGN.md
class AppColors {
  AppColors._();

  // Primary & Stitch Theme
  static const Color primary = Color(0xFF0057CD);
  static const Color primaryContainer = Color(0xFF0D6EFD);
  static const Color onPrimary = Colors.white;
  static const Color secondary = Color(0xFF425C9B);
  static const Color secondaryContainer = Color(0xFFA0BAFF);

  // Surface & Background (Light)
  static const Color surface = Color(0xFFF8FAFB);
  static const Color surfaceContainer = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F5);
  static const Color surfaceContainerHigh = Color(0xFFE6E8E9);
  static const Color surfaceContainerHighest = Color(0xFFE1E3E4);
  static const Color onSurface = Color(0xFF1A1C1E);
  static const Color onSurfaceVariant = Color(0xFF424655);
  static const Color outline = Color(0xFFDDE1E6);
  static const Color outlineVariant = Color(0xFFC2C6D8);

  // Stitch Accents & Fixed Colors
  static const Color primaryFixed = Color(0xFFDAE2FF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color tertiaryFixed = Color(0xFFFFDBCE);

  // Status Colors (Light)
  static const Color statusSafe = Color(0xFF10B981);     // AMAN / Optimal
  static const Color statusWarning = Color(0xFFF59E0B);  // WASPADA
  static const Color statusDanger = Color(0xFFEF4444);   // BAHAYA / Kritis

  // Status Gradients (for banners)
  static const List<Color> safeGradient = [
    Color(0xFF10B981),
    Color(0xFF059669),
  ];
  static const List<Color> warningGradient = [
    Color(0xFFF59E0B),
    Color(0xFFD97706),
  ];
  static const List<Color> dangerGradient = [
    Color(0xFFEF4444),
    Color(0xFFDC2626),
  ];

  // Sensor Specific Colors
  static const Color suhuAccent = Color(0xFFEF4444);      // Suhu: coral/red accent
  static const Color doAccent = Color(0xFF0057CD);        // DO: rich blue
  static const Color turbidityAccent = Color(0xFFF59E0B); // Turbidity: amber
  static const Color jarakAccent = Color(0xFF0057CD);     // LoRa distance: primary
  static const Color sinyalAccent = Color(0xFF10B981);    // RSSI signal: green

  // Utility
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Colors.white;

  // Dark variant colors (from DESIGN.md)
  static const Color primaryDark = Color(0xFF4DA3FF);
  static const Color primaryContainerDark = Color(0xFF003A8C);
  static const Color surfaceDark = Color(0xFF121820);
  static const Color surfaceContainerDark = Color(0xFF1B2530);
  static const Color onSurfaceDark = Color(0xFFE2E5E9);
  static const Color onSurfaceVariantDark = Color(0xFF8E959E);
  static const Color outlineDark = Color(0xFF2A3544);
  static const Color errorDark = Color(0xFFFF6B6B);
  static const Color statusSafeDark = Color(0xFF34D399);
  static const Color statusWarningDark = Color(0xFFFBBF24);
  static const Color statusDangerDark = Color(0xFFF87171);
}
