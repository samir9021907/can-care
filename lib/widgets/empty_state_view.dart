import 'package:flutter/material.dart';

class LeafMagnifierIllustration extends StatelessWidget {
  final double size;

  const LeafMagnifierIllustration({super.key, this.size = 110});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _LeafMagnifierPainter(),
    );
  }
}

class _LeafMagnifierPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Soft circular aura behind illustration
    final auraPaint = Paint()
      ..color = const Color(0xFFE8F5E9).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.45, h * 0.45), w * 0.42, auraPaint);

    // Leaf outline & fill
    final leafPath = Path();
    leafPath.moveTo(w * 0.20, h * 0.85);
    leafPath.cubicTo(w * 0.15, h * 0.50, w * 0.35, h * 0.20, w * 0.65, h * 0.12);
    leafPath.cubicTo(w * 0.75, h * 0.40, w * 0.60, h * 0.75, w * 0.20, h * 0.85);
    leafPath.close();

    final leafFill = Paint()
      ..color = const Color(0xFFC8E6C9)
      ..style = PaintingStyle.fill;
    canvas.drawPath(leafPath, leafFill);

    final leafStroke = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(leafPath, leafStroke);

    // Central leaf vein
    final veinPaint = Paint()
      ..color = const Color(0xFF388E3C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final vein = Path();
    vein.moveTo(w * 0.20, h * 0.85);
    vein.quadraticBezierTo(w * 0.45, h * 0.52, w * 0.65, h * 0.12);
    canvas.drawPath(vein, veinPaint);

    // Magnifying Glass
    final center = Offset(w * 0.60, h * 0.55);
    final radius = w * 0.22;

    // Glass circle fill (translucent)
    final glassFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, glassFill);

    // Glass ring border
    final glassBorder = Paint()
      ..color = const Color(0xFF1B5E20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(center, radius, glassBorder);

    // Glass handle
    final handlePaint = Paint()
      ..color = const Color(0xFF1B5E20)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;
    canvas.drawLine(
      Offset(center.dx + radius * 0.7, center.dy + radius * 0.7),
      Offset(center.dx + radius * 1.55, center.dy + radius * 1.55),
      handlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EmptyStateView extends StatelessWidget {
  final IconData? icon;
  final Widget? customIllustration;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateView({
    super.key,
    this.icon,
    this.customIllustration,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customIllustration ??
                (icon != null
                    ? Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F5E9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 38, color: const Color(0xFF2E7D32)),
                      )
                    : const LeafMagnifierIllustration(size: 110)),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF14451D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF5A7262),
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 22),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF165228),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: Text(
                    buttonText!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
