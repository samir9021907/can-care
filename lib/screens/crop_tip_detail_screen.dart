import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import '../localization/app_localizations.dart';
import '../models/crop_tip.dart';

class CropTipDetailScreen extends StatelessWidget {
  final CropTip tip;

  const CropTipDetailScreen({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final displayTitle = loc.language == AppLanguage.marathi ? tip.marathiTitle : tip.title;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(displayTitle),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkGreen),
        titleTextStyle: AppTypography.heading3,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.space12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.cardAccentGradient,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusCard),
                  boxShadow: AppDimensions.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        tip.category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tip.title,
                      style: AppTypography.heading1.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tip.marathiTitle,
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.lightGreen,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Educational Scope Disclaimer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.creamAccent,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusButton),
                  border: Border.all(
                      color: AppColors.warmYellow.withValues(alpha: 0.6)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.school_outlined,
                        color: Color(0xFFF57F17), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        tip.cautionNote,
                        style: AppTypography.caption.copyWith(
                          color: const Color(0xFF5D4037),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusCard),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppDimensions.subtleShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Management Objective',
                      style: AppTypography.titleLarge.copyWith(
                        fontSize: 15,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tip.summary,
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Best Practice Guidelines
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusCard),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppDimensions.subtleShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Step-by-Step Field Guidelines',
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 15,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...tip.guidelines.map(
                      (g) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Icon(Icons.circle,
                                  size: 6, color: AppColors.primary),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                g,
                                style: AppTypography.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
