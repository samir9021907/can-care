import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? statusBadge; // 'loading', 'success', 'cancelled', 'error'

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.statusBadge,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.border;
    Color bgColor = Colors.white;
    Widget statusWidget = const SizedBox.shrink();

    if (statusBadge == 'success') {
      borderColor = AppColors.success;
      bgColor = AppColors.mintSurface;
      statusWidget = const Icon(Icons.check_circle_rounded,
          color: AppColors.success, size: 18);
    } else if (statusBadge == 'error') {
      borderColor = AppColors.error;
      statusWidget =
          const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18);
    } else if (statusBadge == 'cancelled') {
      borderColor = AppColors.warning;
      statusWidget = const Icon(Icons.cancel_outlined,
          color: AppColors.warning, size: 18);
    }

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Connecting to Google...',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3E33),
                    ),
                  ),
                ] else ...[
                  // Authentic 4-color Google 'G' Mark
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CustomPaint(
                      painter: GoogleLogoPainter(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3E33),
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (statusBadge != null) ...[
                    const SizedBox(width: 8),
                    statusWidget,
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the official 4-color Google 'G' emblem
class GoogleLogoPainter extends CustomPainter {
  const GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Red: Top sweep (195 to 330 deg approx)
    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, 3.4, 1.8, false, redPaint);

    // Yellow: Left arc
    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, 2.3, 1.2, false, yellowPaint);

    // Green: Bottom sweep
    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, 0.7, 1.7, false, greenPaint);

    // Blue: Right arc & crossbar
    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, -0.4, 1.2, false, bluePaint);

    // Crossbar fill
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final barRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.46, h * 0.40, w * 0.98, h * 0.60),
      const Radius.circular(1.5),
    );
    canvas.drawRRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
