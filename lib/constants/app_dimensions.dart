import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  // Spacing (8px system)
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;

  // Border Radii
  static const double radiusSmall = 8.0;
  static const double radiusButton = 12.0; // ~12px rounded buttons
  static const double radiusCard = 16.0; // ~16px rounded cards
  static const double radiusLarge = 24.0;
  static const double radiusL = 24.0; // Alias for radiusLarge
  static const double radiusPill = 999.0;

  // Touch Target
  static const double minTouchTarget = 48.0; // Minimum 48px touch target
  static const double buttonHeight = 52.0;

  // Card & Elevation Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF153B28).withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: const Color(0xFF153B28).withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
