import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Large layered green circular shield badge with progress ring matching Image 1
class VerifyingShieldGraphic extends StatelessWidget {
  final double size;
  final double progress; // Progress between 0.0 and 1.0

  const VerifyingShieldGraphic({
    super.key,
    this.size = 180,
    this.progress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final outerSize = size;
    final shieldWidth = outerSize * 0.40;
    final shieldHeight = outerSize * 0.48;

    return SizedBox(
      width: outerSize,
      height: outerSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Large soft pastel green circular backdrop with glow
          Container(
            width: outerSize,
            height: outerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFF1FBF0),
                  Color(0xFFE0F5DD),
                  Color(0xFFD2EED0),
                ],
                stops: [0.35, 0.75, 1.0],
                radius: 0.95,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1B5E20).withValues(alpha: 0.14),
                  blurRadius: 22,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),

          // 2. Inner subtle white concentric ring for layered depth matching Image 1
          Container(
            width: outerSize - 20,
            height: outerSize - 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.75),
                width: 2.2,
              ),
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFF7FCF6),
                  Color(0xFFE2F6DF),
                ],
                radius: 0.85,
              ),
            ),
          ),

          // 3. Outer circular progress ring track & active progress arc (determinate & animated)
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: progress.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
            builder: (context, animatedProgress, child) {
              return CustomPaint(
                size: Size(outerSize, outerSize),
                painter: _ShieldProgressRingPainter(
                  progress: animatedProgress,
                ),
              );
            },
          ),

          // 4. Central Green Shield with White Checkmark matching Image 1
          CustomPaint(
            size: Size(shieldWidth, shieldHeight),
            painter: const _ShieldBadgePainter(),
          ),
        ],
      ),
    );
  }
}

class _ShieldProgressRingPainter extends CustomPainter {
  final double progress;

  const _ShieldProgressRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 7.0) / 2;

    // Faint mint green background track
    final trackPaint = Paint()
      ..color = const Color(0xFFCBE8C6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6;
    canvas.drawCircle(center, radius, trackPaint);

    // Active progress arc starting at 12 o'clock (-pi / 2) sweeping clockwise
    if (progress > 0.002) {
      final arcPaint = Paint()
        ..color = const Color(0xFF2E7D32)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.4
        ..strokeCap = StrokeCap.round;

      final sweepAngle = (progress * 2 * math.pi).clamp(0.0, 2 * math.pi);
      if (progress >= 0.999) {
        canvas.drawCircle(center, radius, arcPaint);
      } else {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -math.pi / 2,
          sweepAngle,
          false,
          arcPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ShieldProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _ShieldBadgePainter extends CustomPainter {
  const _ShieldBadgePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Shield path matching Image 2
    final path = Path();
    path.moveTo(w * 0.5, 0);
    path.quadraticBezierTo(w * 0.78, h * 0.02, w * 0.94, h * 0.10);
    path.quadraticBezierTo(w * 0.95, h * 0.32, w * 0.93, h * 0.46);
    path.cubicTo(
      w * 0.92, h * 0.74,
      w * 0.65, h * 0.92,
      w * 0.5, h,
    );
    path.cubicTo(
      w * 0.35, h * 0.92,
      w * 0.08, h * 0.74,
      w * 0.07, h * 0.46,
    );
    path.quadraticBezierTo(w * 0.05, h * 0.32, w * 0.06, h * 0.10);
    path.quadraticBezierTo(w * 0.22, h * 0.02, w * 0.5, 0);
    path.close();

    // Drop shadow under shield
    canvas.drawShadow(
      path,
      const Color(0xFF14451D).withValues(alpha: 0.32),
      8,
      false,
    );

    // Shield gradient fill
    final rect = Offset.zero & size;
    final gradient = const LinearGradient(
      colors: [Color(0xFF338A37), Color(0xFF1E6C24)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final fillPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // White Checkmark in center
    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final checkPath = Path();
    checkPath.moveTo(w * 0.30, h * 0.48);
    checkPath.lineTo(w * 0.44, h * 0.62);
    checkPath.lineTo(w * 0.70, h * 0.36);

    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Large green success circle with white checkmark and radiating celebratory flecks
/// Features a lively breathing pulse ("motha par kammi / lop-lop") and interactive hover effect.
class WelcomeSuccessGraphic extends StatefulWidget {
  final double size;

  const WelcomeSuccessGraphic({super.key, this.size = 110});

  @override
  State<WelcomeSuccessGraphic> createState() => _WelcomeSuccessGraphicState();
}

class _WelcomeSuccessGraphicState extends State<WelcomeSuccessGraphic>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _rippleScaleAnimation;
  late Animation<double> _rippleOpacityAnimation;
  late Animation<double> _fleckRotationAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Breathing scale: smoothly expands and contracts ("motha par kammi")
    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.07).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Pulsing glow intensity ("lop-lop" lighting effect)
    _glowAnimation = Tween<double>(begin: 0.22, end: 0.48).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Expanding soft ripple wave
    _rippleScaleAnimation = Tween<double>(begin: 0.96, end: 1.26).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutQuad,
      ),
    );

    _rippleOpacityAnimation = Tween<double>(begin: 0.32, end: 0.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutQuad,
      ),
    );

    // Subtle celebration flecks micro-rotation
    _fleckRotationAnimation = Tween<double>(begin: -0.06, end: 0.06).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final totalSize = size + 56;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final hoverScale = _isHovered ? 1.08 : 1.0;
          final currentScale = _scaleAnimation.value * hoverScale;
          final glowAlpha = _isHovered ? 0.60 : _glowAnimation.value;

          return SizedBox(
            width: totalSize,
            height: totalSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Soft pulsing ripple / halo ring behind circle ("lop lop" ambient glow)
                Transform.scale(
                  scale: _rippleScaleAnimation.value * hoverScale,
                  child: Container(
                    width: size + 14,
                    height: size + 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(
                        alpha: _rippleOpacityAnimation.value,
                      ),
                    ),
                  ),
                ),

                // 2. Radiating celebration leaf/fleck particles that pulse & micro-rotate
                Transform.rotate(
                  angle: _fleckRotationAnimation.value,
                  child: Transform.scale(
                    scale: 0.95 + (_scaleAnimation.value - 0.94) * 0.7,
                    child: CustomPaint(
                      size: Size(totalSize, totalSize),
                      painter: const _CelebrationFlecksPainter(),
                    ),
                  ),
                ),

                // 3. Main green circle with white checkmark that breathes ("motha par kammi")
                Transform.scale(
                  scale: currentScale,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF2E7D32),
                          Color(0xFF1B5E20),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: glowAlpha),
                          blurRadius: 18 + (_scaleAnimation.value - 0.94) * 45,
                          spreadRadius: 2 + (_scaleAnimation.value - 0.94) * 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: size * 0.58,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CelebrationFlecksPainter extends CustomPainter {
  const _CelebrationFlecksPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final goldPaint = Paint()
      ..color = const Color(0xFFF9A825).withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;
    final greenPaint = Paint()
      ..color = const Color(0xFF81C784).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    // Small celebratory confetti/leaf flecks radiating around the circle
    final angles = [
      0.35,
      0.75,
      1.25,
      1.9,
      2.4,
      3.55,
      4.1,
      4.8,
      5.3,
      5.8,
    ];

    for (int i = 0; i < angles.length; i++) {
      final angle = angles[i];
      final dist = (size.width / 2) * 0.88;
      final x = center.dx + dist * math.cos(angle);
      final y = center.dy + dist * math.sin(angle);
      final paint = i % 2 == 0 ? goldPaint : greenPaint;

      // Draw oval leaf fleck rotated along radiating angle
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-3, -7, 6, 14),
          const Radius.circular(3),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
