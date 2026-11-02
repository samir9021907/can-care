import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CaneCare AI Terms of Service',
                  style: AppTypography.heading2.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  'Updated: 2026 Season • Version 1.0',
                  style: AppTypography.caption,
                ),
                const Divider(height: 24),
                _buildSection(
                  '1. Acceptance of Terms',
                  'By accessing or using CaneCare AI, you agree to these Terms of Service. If you disagree with any part of these terms, please do not use the application.',
                ),
                _buildSection(
                  '2. Agronomic Advisory Limitation',
                  'CaneCare AI provides automated visual indications based on computer vision analysis of sugarcane leaf imagery. It is intended as an early advisory screening tool and does NOT replace licensed agronomic prescriptions from State Agricultural Universities or registered Krishi Vigyan Kendra (KVK) officers.',
                ),
                _buildSection(
                  '3. Chemical Treatment Responsibility',
                  'CaneCare AI does NOT formulate or guarantee chemical pesticide or fungicide dosages. Users must verify all chemical applications, pre-harvest intervals, and safety precautions with local agricultural extension officers.',
                ),
                _buildSection(
                  '4. Frontend Demo Phase',
                  'The current release represents the complete frontend interface phase. Predictive outputs and confidence percentages in this build are illustrative demo simulations to validate user experience before Python deep learning pipeline deployment.',
                ),
                _buildSection(
                  '5. User Conduct',
                  'Users agree to capture photos of actual crop foliage and refrain from uploading harmful, offensive, or malicious content.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.titleLarge
                .copyWith(fontSize: 14, color: AppColors.darkGreen),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: AppTypography.bodySmall.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
