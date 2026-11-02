import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class ConfidenceMeter extends StatelessWidget {
  final double score; // 0.0 to 1.0
  final bool isDemo;

  const ConfidenceMeter({
    super.key,
    required this.score,
    this.isDemo = true,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score * 100).clamp(0, 100).toStringAsFixed(1);
    final color = score >= 0.85
        ? AppColors.primary
        : score >= 0.60
            ? AppColors.warmYellow
            : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.analytics_outlined, size: 16, color: color),
                  const SizedBox(width: 6),
                  Text(
                    'Prediction Confidence',
                    style: AppTypography.titleLarge.copyWith(fontSize: 13),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.mintSurface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'DEMO DATA',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: score,
                    minHeight: 8,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Illustrative confidence score for frontend interface preview.',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
