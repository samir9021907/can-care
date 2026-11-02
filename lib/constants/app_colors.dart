import 'package:flutter/material.dart';

/// Design tokens and palette for CaneCare AI matching the specification
class AppColors {
  AppColors._();

  // Primary Agriculture Greens matching Reference Specification
  static const Color primary = Color(0xFF2E7D32); // Primary deep green (#2E7D32)
  static const Color darkGreen = Color(0xFF124D2C); // Dark green (#124D2C)
  static const Color lightGreen = Color(0xFFA5D6A7); // Light green (#A5D6A7)
  static const Color paleGreen = Color(0xFFEEF5E5); // Pale green (#EEF5E5)
  static const Color mintSurface = Color(0xFFEEF5E5); // Pale mint tint
  static const Color leafAccent = Color(0xFF388E3C);

  // Backgrounds & Accents
  static const Color background = Color(0xFFF7FAF5); // Main background (#F7FAF5)
  static const Color cream = Color(0xFFF2EDC9); // Cream accent (#F2EDC9)
  static const Color creamAccent = Color(0xFFF2EDC9); // Cream accent
  static const Color cardSurface = Colors.white;
  static const Color border = Color(0xFFD4DEC9);
  static const Color inputBorder = Color(0xFFD4DEC9);
  static const Color divider = Color(0xFFECEFE8);

  // Status & Warnings
  static const Color warmYellow = Color(0xFFF9A825); // Warm yellow (#F9A825)
  static const Color error = Color(0xFFE53935); // Error red (#E53935)
  static const Color warning = Color(0xFFEF6C00); // Warning
  static const Color success = Color(0xFF2E7D32); // Success
  static const Color infoBlue = Color(0xFF1976D2); // Information

  // Text Colors
  static const Color textMain = Color(0xFF153B28); // Main text
  static const Color textSecondary = Color(0xFF607568); // Secondary text
  static const Color textMuted = Color(0xFF8FA395);
  static const Color textLight = Colors.white;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2E7D32),
      Color(0xFF14532D),
    ],
  );

  static const LinearGradient cardAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF388E3C),
      Color(0xFF1B5E20),
    ],
  );

  static const LinearGradient heroCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E5B26),
      Color(0xFF14451D),
    ],
  );

  static const LinearGradient laserGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0x33A5D6A7),
      Color(0xFF2E7D32),
    ],
  );
}
