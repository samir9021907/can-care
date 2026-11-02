import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Weather sun and cloud illustration matching the CaneCare AI Weather screen reference image.
/// Displays a vibrant golden sun with radiating rays behind a soft sky-blue fluffy cloud.
class WeatherSunCloudGraphic extends StatelessWidget {
  final double size;

  const WeatherSunCloudGraphic({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _SunAndCloudPainter(),
      ),
    );
  }
}

class _SunAndCloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Sun Center & Rays (Upper-Left of widget)
    final sunCenter = Offset(w * 0.42, h * 0.38);
    final sunRadius = w * 0.22;

    final rayPaint = Paint()
      ..color = const Color(0xFFF9A825)
      ..strokeWidth = w * 0.045
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // 8 Sun Rays
    final rayCount = 8;
    final rayInnerDist = sunRadius + (w * 0.05);
    final rayOuterDist = sunRadius + (w * 0.15);

    for (int i = 0; i < rayCount; i++) {
      final angle = (i * 2 * math.pi) / rayCount;
      final start = Offset(
        sunCenter.dx + rayInnerDist * math.cos(angle),
        sunCenter.dy + rayInnerDist * math.sin(angle),
      );
      final end = Offset(
        sunCenter.dx + rayOuterDist * math.cos(angle),
        sunCenter.dy + rayOuterDist * math.sin(angle),
      );
      canvas.drawLine(start, end, rayPaint);
    }

    // Sun Disc with warm yellow/gold gradient
    final sunPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFEE58), Color(0xFFFDD835), Color(0xFFF9A825)],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: sunRadius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(sunCenter, sunRadius, sunPaint);

    // 2. Soft Sky-Blue Cloud (Lower-Right overlapping sun)
    final cloudPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF81D4FA), // Sky blue highlight
          Color(0xFF4FC3F7), // Medium cyan-blue
          Color(0xFF29B6F6),
        ],
      ).createShader(Rect.fromLTWH(w * 0.20, h * 0.40, w * 0.72, h * 0.50))
      ..style = PaintingStyle.fill;

    // Cloud shadow
    final cloudShadowPaint = Paint()
      ..color = const Color(0xFF0288D1).withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Cloud Path composed of overlapping circular puffs and flat bottom base
    Path buildCloudPath() {
      final path = Path();
      final baseLeft = w * 0.25;
      final baseRight = w * 0.88;
      final baseBottom = h * 0.82;
      final baseTop = h * 0.65;

      // Flat/rounded bottom base
      path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTRB(baseLeft, baseTop, baseRight, baseBottom),
        Radius.circular(w * 0.12),
      ));

      // Left puff
      path.addOval(Rect.fromCircle(
        center: Offset(w * 0.40, h * 0.60),
        radius: w * 0.16,
      ));

      // Main center high puff
      path.addOval(Rect.fromCircle(
        center: Offset(w * 0.62, h * 0.52),
        radius: w * 0.20,
      ));

      // Right puff
      path.addOval(Rect.fromCircle(
        center: Offset(w * 0.78, h * 0.64),
        radius: w * 0.14,
      ));

      return path;
    }

    final cloudPath = buildCloudPath();
    canvas.drawPath(cloudPath, cloudShadowPaint);
    canvas.drawPath(cloudPath, cloudPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
