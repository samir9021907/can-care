import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// CaneCare AI signature logo mark matching the Figma design icon.
/// A rounded squircle badge in forest green containing a golden sugarcane stalk
/// and vibrant green chlorophyll leaf.
class CaneLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? backgroundColor;

  const CaneLogo({
    super.key,
    this.size = 56,
    this.showText = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final logoWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withValues(alpha: 0.18),
            blurRadius: size * 0.15,
            offset: Offset(0, size * 0.06),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/cane_logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20),
            borderRadius: BorderRadius.circular(size * 0.28),
          ),
          padding: EdgeInsets.all(size * 0.16),
          child: CustomPaint(
            painter: _CaneLogoFigmaPainter(),
          ),
        ),
      ),
    );

    if (!showText) return logoWidget;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logoWidget,
        const SizedBox(width: 10),
        const Text(
          'CaneCare AI',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGreen,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}

class _CaneLogoFigmaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Golden sugarcane stalk with nodes (on left side)
    final stalkPaint = Paint()
      ..color = const Color(0xFFFFD54F) // Warm gold/yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.13
      ..strokeCap = StrokeCap.round;

    final nodePaint = Paint()
      ..color = const Color(0xFFFFC107)
      ..style = PaintingStyle.fill;

    final stalkX = size.width * 0.38;
    canvas.drawLine(
      Offset(stalkX, size.height * 0.25),
      Offset(stalkX, size.height * 0.82),
      stalkPaint,
    );

    // Node bands
    canvas.drawCircle(Offset(stalkX, size.height * 0.44), size.width * 0.08, nodePaint);
    canvas.drawCircle(Offset(stalkX, size.height * 0.64), size.width * 0.08, nodePaint);

    // 2. Leaf curling out and up to top right (chlorophyll green)
    final leafPaint = Paint()
      ..color = const Color(0xFF81C784) // Fresh bright leaf green
      ..style = PaintingStyle.fill;

    final leafPath = Path();
    leafPath.moveTo(stalkX, size.height * 0.44);
    leafPath.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.12,
      size.width * 0.88,
      size.height * 0.28,
    );
    leafPath.quadraticBezierTo(
      size.width * 0.65,
      size.height * 0.42,
      stalkX,
      size.height * 0.48,
    );
    canvas.drawPath(leafPath, leafPaint);

    // Secondary smaller lower sprout
    final leaf2 = Path();
    leaf2.moveTo(stalkX, size.height * 0.64);
    leaf2.quadraticBezierTo(
      size.width * 0.78,
      size.height * 0.52,
      size.width * 0.82,
      size.height * 0.64,
    );
    leaf2.quadraticBezierTo(
      size.width * 0.60,
      size.height * 0.70,
      stalkX,
      size.height * 0.68,
    );
    canvas.drawPath(leaf2, leafPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
