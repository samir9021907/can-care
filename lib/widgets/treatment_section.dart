import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import '../models/treatment_guidance.dart';

class TreatmentSection extends StatelessWidget {
  final TreatmentGuidance treatment;

  const TreatmentSection({super.key, required this.treatment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cultural Practices Section
        _buildCareBlock(
          icon: Icons.agriculture_outlined,
          title: 'Cultural Practices',
          items: treatment.culturalPractices,
          iconColor: AppColors.primary,
        ),
        const SizedBox(height: 14),

        // Organic & Bio-control Measures
        _buildCareBlock(
          icon: Icons.eco_outlined,
          title: 'Organic & Bio-Control Measures',
          items: treatment.organicMeasures,
          iconColor: AppColors.leafAccent,
        ),
        const SizedBox(height: 14),

        // Prevention Guidance
        _buildCareBlock(
          icon: Icons.shield_outlined,
          title: 'Long-Term Prevention',
          items: treatment.generalPreventiveSteps,
          iconColor: const Color(0xFF1565C0),
        ),
        const SizedBox(height: 16),

        // Mandatory Agricultural Expert Advisory
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: AppColors.warmYellow.withValues(alpha: 0.6)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: Color(0xFFF57F17), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Official Agricultural Advisory Notice',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE65100),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      treatment.expertAdvisoryNote,
                      style: AppTypography.bodySmall.copyWith(
                        color: const Color(0xFF5D4037),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCareBlock({
    required IconData icon,
    required String title,
    required List<String> items,
    required Color iconColor,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border),
        boxShadow: AppDimensions.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 15,
                  color: AppColors.darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map((step) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(Icons.circle,
                          size: 6, color: AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        step,
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.textMain),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
