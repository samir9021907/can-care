import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography specification for CaneCare AI matching design tokens
/// Uses Poppins for bold headings, Inter for clear body text, with system fallbacks
class AppTypography {
  AppTypography._();

  static const List<String> headingFallbacks = [
    'Poppins',
    'Inter',
    'Roboto',
    'sans-serif',
  ];

  static const List<String> bodyFallbacks = [
    'Inter',
    'Roboto',
    'sans-serif',
  ];

  static TextStyle get heading1 => const TextStyle(
        fontFamily: 'Poppins',
        fontFamilyFallback: headingFallbacks,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textMain,
        letterSpacing: -0.5,
        height: 1.25,
      );

  static TextStyle get heading2 => const TextStyle(
        fontFamily: 'Poppins',
        fontFamilyFallback: headingFallbacks,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textMain,
        letterSpacing: -0.3,
        height: 1.3,
      );

  static TextStyle get heading3 => const TextStyle(
        fontFamily: 'Poppins',
        fontFamilyFallback: headingFallbacks,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textMain,
        letterSpacing: -0.2,
      );

  static TextStyle get titleLarge => const TextStyle(
        fontFamily: 'Inter',
        fontFamilyFallback: bodyFallbacks,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textMain,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: 'Inter',
        fontFamilyFallback: bodyFallbacks,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textMain,
        height: 1.5,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: 'Inter',
        fontFamilyFallback: bodyFallbacks,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.45,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: 'Inter',
        fontFamilyFallback: bodyFallbacks,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get buttonText => const TextStyle(
        fontFamily: 'Inter',
        fontFamilyFallback: bodyFallbacks,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle get caption => const TextStyle(
        fontFamily: 'Inter',
        fontFamilyFallback: bodyFallbacks,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      );

  static TextStyle get badgeText => const TextStyle(
        fontFamily: 'Inter',
        fontFamilyFallback: bodyFallbacks,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      );
}
