import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import 'contact_support_screen.dart';
import 'feedback_screen.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help & Support'),
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
            // Hero Help Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusCard),
                boxShadow: AppDimensions.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.support_agent_rounded,
                      color: Colors.white, size: 36),
                  const SizedBox(height: 12),
                  Text(
                    'How can we assist you today?',
                    style: AppTypography.heading2.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Find answers to common questions about leaf scanning or reach out to our team.',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions: Contact & Feedback
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContactSupportScreen(),
                        ),
                      );
                    },
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusCard),
                    child: Container(
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
                          const Icon(Icons.call_outlined,
                              color: AppColors.primary, size: 28),
                          const SizedBox(height: 10),
                          Text('Contact Us',
                              style: AppTypography.titleLarge
                                  .copyWith(fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('Helpline & KVK',
                              style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FeedbackScreen(),
                        ),
                      );
                    },
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusCard),
                    child: Container(
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
                          const Icon(Icons.rate_review_outlined,
                              color: Color(0xFFE65100), size: 28),
                          const SizedBox(height: 10),
                          Text('Send Feedback',
                              style: AppTypography.titleLarge
                                  .copyWith(fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('Share thoughts',
                              style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Frequently Asked Questions
            Text(
              'Frequently Asked Questions',
              style: AppTypography.heading3.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),

            _buildFaqTile(
              'How should I photograph sugarcane leaves for best diagnosis?',
              'Hold phone steady 15-20 cm away from a single, fully unrolled leaf under natural daylight. Avoid harsh shadows, heavy dust, or camera glare.',
            ),
            _buildFaqTile(
              'Does CaneCare AI replace laboratory leaf tests?',
              'No. CaneCare AI provides preliminary visual screening. Some fungal infections and viral strains require official university or KVK pathology lab confirmation before chemical application.',
            ),
            _buildFaqTile(
              'Can I use CaneCare AI without an active internet connection?',
              'Saved past reports and the Sugarcane Disease Encyclopedia work completely offline. New AI leaf scanning requires internet connectivity in the final production release.',
            ),
            _buildFaqTile(
              'Which diseases can be identified?',
              'Currently supported sugarcane conditions include Healthy foliage, Sugarcane Rust, Yellow Leaf Disease (YLD), Sugarcane Mosaic, Red Rot, and Smut.',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTypography.titleLarge.copyWith(fontSize: 14),
        ),
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.textSecondary,
        childrenPadding:
            const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            answer,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
