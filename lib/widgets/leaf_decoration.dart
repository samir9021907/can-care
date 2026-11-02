import 'package:flutter/material.dart';

/// Painter for the subtle watercolor foliage illustrated at the bottom
/// of screens 1, 2, 8, 13, 20 in the Figma design.
class LeafDecorationPainter extends CustomPainter {
  final Color leafColor;
  final double opacity;

  const LeafDecorationPainter({
    this.leafColor = const Color(0xFF66BB6A),
    this.opacity = 0.22,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = leafColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = leafColor.withValues(alpha: opacity * 1.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Left curved leaf 1
    final path1 = Path();
    path1.moveTo(0, size.height * 0.95);
    path1.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.45,
      size.width * 0.35,
      size.height * 0.30,
    );
    path1.quadraticBezierTo(
      size.width * 0.32,
      size.height * 0.65,
      0,
      size.height,
    );
    canvas.drawPath(path1, paint);
    canvas.drawLine(
      Offset(0, size.height * 0.95),
      Offset(size.width * 0.35, size.height * 0.30),
      linePaint,
    );

    // Left curved leaf 2
    final path2 = Path();
    path2.moveTo(size.width * 0.08, size.height);
    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.60,
      size.width * 0.45,
      size.height * 0.50,
    );
    path2.quadraticBezierTo(
      size.width * 0.38,
      size.height * 0.78,
      size.width * 0.15,
      size.height,
    );
    canvas.drawPath(path2, paint);

    // Right curved leaf 1
    final path3 = Path();
    path3.moveTo(size.width, size.height * 0.90);
    path3.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.40,
      size.width * 0.65,
      size.height * 0.25,
    );
    path3.quadraticBezierTo(
      size.width * 0.68,
      size.height * 0.60,
      size.width,
      size.height,
    );
    canvas.drawPath(path3, paint);
    canvas.drawLine(
      Offset(size.width, size.height * 0.90),
      Offset(size.width * 0.65, size.height * 0.25),
      linePaint,
    );

    // Right curved leaf 2
    final path4 = Path();
    path4.moveTo(size.width * 0.92, size.height);
    path4.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.55,
      size.width * 0.55,
      size.height * 0.45,
    );
    path4.quadraticBezierTo(
      size.width * 0.62,
      size.height * 0.75,
      size.width * 0.85,
      size.height,
    );
    canvas.drawPath(path4, paint);
  }

  @override
  bool shouldRepaint(covariant LeafDecorationPainter oldDelegate) => false;
}

class LeafDecorationBackground extends StatelessWidget {
  final double height;

  const LeafDecorationBackground({super.key, this.height = 140});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: height,
      child: IgnorePointer(
        child: CustomPaint(
          size: Size(double.infinity, height),
          painter: const LeafDecorationPainter(),
        ),
      ),
    );
  }
}
