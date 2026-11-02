import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
                  'CaneCare AI Privacy Commitment',
                  style: AppTypography.heading2.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  'Effective Date: 2026 Season • Version 1.0',
                  style: AppTypography.caption,
                ),
                const Divider(height: 24),
                _buildSection(
                  '1. Information We Collect',
                  'In this frontend demonstration phase, all profile details and leaf scan logs are processed locally on your device. We do not transmit or sell personal farmer data to third-party commercial brokers.',
                ),
                _buildSection(
                  '2. Sugarcane Leaf Imagery',
                  'Foliage photographs captured via the camera or chosen from your gallery are analyzed solely for the purpose of plant disease identification. In future cloud phases, images may be anonymously used to refine agricultural AI models with explicit user consent.',
                ),
                _buildSection(
                  '3. Device Permissions',
                  'CaneCare AI requests Camera access to frame and capture live leaf samples, and Storage/Gallery access to select existing farm photos. You can revoke these permissions at any time via Android system settings.',
                ),
                _buildSection(
                  '4. Local Data Storage',
                  'Scan histories and diagnostic reports are stored in local sandbox storage on your Android device and can be erased anytime using the Delete Report option.',
                ),
                _buildSection(
                  '5. Contact for Inquiries',
                  'Questions regarding data practices may be directed to privacy@canecare.ai.',
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
