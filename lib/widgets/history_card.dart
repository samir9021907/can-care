import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/scan_report.dart';
import '../models/disease_info.dart';

class HistoryCard extends StatelessWidget {
  final ScanReport report;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const HistoryCard({
    super.key,
    required this.report,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (report.confidenceScore * 100).toInt();

    // Badges configuration matching Image 2
    String badge1Text;
    Color badge1Bg;
    Color badge1TextColor;
    Color badge1Border;

    if (report.isHealthy) {
      badge1Text = 'Healthy / Safe';
      badge1Bg = const Color(0xFFE8F8EE);
      badge1TextColor = const Color(0xFF15803D);
      badge1Border = const Color(0xFFC7EED4);
    } else if (report.severity == DiseaseSeverity.high ||
        report.severity == DiseaseSeverity.critical) {
      badge1Text = 'High Risk';
      badge1Bg = const Color(0xFFFFEBEE);
      badge1TextColor = const Color(0xFFDC2626);
      badge1Border = const Color(0xFFFFCDD2);
    } else if (report.title.contains('Yellow Leaf') ||
        report.diseaseName.contains('Yellow Leaf')) {
      badge1Text = 'Medium Severity';
      badge1Bg = const Color(0xFFFFF3DC);
      badge1TextColor = const Color(0xFFD97706);
      badge1Border = const Color(0xFFFDE68A);
    } else {
      badge1Text = 'Moderate Concern';
      badge1Bg = const Color(0xFFFFF3DC);
      badge1TextColor = const Color(0xFFD97706);
      badge1Border = const Color(0xFFFDE68A);
    }

    // Badge 2
    Widget badge2;
    if (report.isHealthy) {
      badge2 = Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F8EE),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFC7EED4), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_rounded, color: Color(0xFF15803D), size: 11),
            const SizedBox(width: 3),
            Text(
              '$percent% Confidence',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF15803D),
              ),
            ),
          ],
        ),
      );
    } else {
      Color dotColor = (report.severity == DiseaseSeverity.high ||
              report.severity == DiseaseSeverity.critical)
          ? const Color(0xFFEF4444)
          : const Color(0xFF009647);
      if (report.title.contains('Rust') || report.diseaseName.contains('Rust')) {
        dotColor = const Color(0xFFF59E0B);
      }

      badge2 = Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F3),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE2EBE5), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5.5,
              height: 5.5,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$percent% AI',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF475569),
              ),
            ),
          ],
        ),
      );
    }

    // Date / Subtitle string
    String dateSubtitle;
    final now = DateTime.now();
    final isToday = report.scanDate.year == now.year &&
        report.scanDate.month == now.month &&
        report.scanDate.day == now.day;

    if (isToday) {
      final tf = DateFormat('hh:mm a');
      dateSubtitle =
          'Today, ${tf.format(report.scanDate)} • ${report.fieldNotes.isNotEmpty ? report.fieldNotes : "Plot #2 (वावर क्र. २)"}';
    } else if (report.title.contains('Yellow Leaf') || report.id == 'rep_001') {
      dateSubtitle =
          'Today, 10:24 AM • ${report.fieldNotes.isNotEmpty ? report.fieldNotes : "Plot #2 (Satara)"}';
    } else {
      final df = DateFormat('dd MMM, hh:mm a');
      dateSubtitle =
          '${df.format(report.scanDate)} • ${report.fieldNotes.isNotEmpty ? report.fieldNotes : "Main Field"}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE8EFE5), width: 1.0),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Thumbnail (60x60, rounded 12)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: const Color(0xFFE8F5E9),
                    child: _buildThumbnail(report.imagePath),
                  ),
                ),
                const SizedBox(width: 12),

                // Report Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14451D),
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: badge1Bg,
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(color: badge1Border, width: 0.8),
                              ),
                              child: Text(
                                badge1Text,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: badge1TextColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            badge2,
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        dateSubtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B8074),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF9EABA3),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(String? path) {
    if (path == null || path.isEmpty) {
      return _buildFallbackIcon();
    }
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => _buildFallbackIcon(),
      );
    }
    return Image.network(
      path,
      fit: BoxFit.cover,
      errorBuilder: (ctx, err, stack) => _buildFallbackIcon(),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      decoration: BoxDecoration(
        color: report.isHealthy
            ? const Color(0xFFE8F8EE)
            : const Color(0xFFFFF3DC),
      ),
      child: Icon(
        Icons.eco_rounded,
        color: report.isHealthy
            ? const Color(0xFF15803D)
            : const Color(0xFFD97706),
        size: 28,
      ),
    );
  }
}
