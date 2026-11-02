import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/disease_info.dart';

class SeverityBadge extends StatelessWidget {
  final DiseaseSeverity severity;
  final bool isDemoBadge;

  const SeverityBadge({
    super.key,
    required this.severity,
    this.isDemoBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    switch (severity) {
      case DiseaseSeverity.none:
        bg = AppColors.mintSurface;
        fg = AppColors.success;
        icon = Icons.check_circle_outline;
        break;
      case DiseaseSeverity.low:
        bg = const Color(0xFFFFF9C4);
        fg = const Color(0xFFF57F17);
        icon = Icons.info_outline;
        break;
      case DiseaseSeverity.moderate:
        bg = const Color(0xFFFFE0B2);
        fg = AppColors.warning;
        icon = Icons.warning_amber_rounded;
        break;
      case DiseaseSeverity.high:
      case DiseaseSeverity.critical:
        bg = const Color(0xFFFFEBEE);
        fg = AppColors.error;
        icon = Icons.dangerous_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 5),
          Text(
            '${severity.label.toUpperCase()} SEVERITY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 0.4,
            ),
          ),
          if (isDemoBadge) ...[
            const SizedBox(width: 4),
            Text(
              '(DEMO)',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: fg.withValues(alpha: 0.75),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
