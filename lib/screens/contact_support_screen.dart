import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import '../widgets/app_snackbar.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contact Support'),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkGreen),
        titleTextStyle: AppTypography.heading3,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.space12,
          ),
          children: [
            // Farmer Toll-free Helpline
            _buildContactCard(
              context,
              icon: Icons.phone_in_talk_rounded,
              title: 'Kisan Call Centre (Toll-Free)',
              subtitle: '1800-180-1551 (6:00 AM – 10:00 PM)',
              badge: 'National Agriculture Helpline',
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),

            // CaneCare AI Developer & Technical Support
            _buildContactCard(
              context,
              icon: Icons.email_outlined,
              title: 'Technical Support Desk',
              subtitle: 'support@canecare.ai',
              badge: 'Bug Reports & App Guidance',
              color: const Color(0xFF1565C0),
            ),
            const SizedBox(height: 12),

            // Regional Agricultural University Extension (Maharashtra)
            _buildContactCard(
              context,
              icon: Icons.account_balance_outlined,
              title: 'Vasantdada Sugar Institute (VSI)',
              subtitle: 'Manjari (Bk.), Tal. Haveli, Dist. Pune - 412 307',
              badge: 'Sugarcane Research & Pathology',
              color: const Color(0xFFE65100),
            ),
            const SizedBox(height: 12),

            _buildContactCard(
              context,
              icon: Icons.nature_people_outlined,
              title: 'Mahatma Phule Krishi Vidyapeeth (MPKV)',
              subtitle: 'Rahuri, Ahmednagar, Maharashtra - 413 722',
              badge: 'State Agricultural University',
              color: AppColors.darkGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String badge,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border),
        boxShadow: AppDimensions.subtleShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: AppTypography.titleLarge.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    AppSnackBar.showInfo(
                      context,
                      'Contact info: $subtitle',
                    );
                  },
                  child: Text(
                    'Connect / Details →',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
