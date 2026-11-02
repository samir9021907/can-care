import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/cane_care_header.dart';
import '../widgets/google_sign_in_button.dart';
import 'account_success_screen.dart';

/// Screen 5: Verifying Account (Google Sign-In Loading) matching Screen 5 in Image 2.
/// Features CaneCare AI logo, rotating circular loader around Google 'G', "Signing you in...",
/// and the security shield badge: "🛡️ This won't take long."
class GoogleVerifyingScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final bool isSignUp;

  const GoogleVerifyingScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    this.isSignUp = true,
  });

  @override
  State<GoogleVerifyingScreen> createState() => _GoogleVerifyingScreenState();
}

class _GoogleVerifyingScreenState extends State<GoogleVerifyingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    // After brief verification, navigate to AccountSuccessScreen
    _navigationTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AccountSuccessScreen(
              userEmail: widget.userEmail,
              isSignUp: widget.isSignUp,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // CaneCare AI Brand Header
              const CaneCareBrandHeader(logoSize: 64),

              const Spacer(flex: 2),

              // Central Loader with concentric rings & Google 'G' logo
              _buildGoogleLoader(170),

              const SizedBox(height: 32),

              // Heading: Signing you in...
              const Text(
                'Signing you in...',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                  letterSpacing: -0.3,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Subtitle: Please wait while we verify your account.
              const Text(
                'Please wait while we verify\nyour account.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF5A7262),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Pill Badge: 🛡️ This won't take long.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F3E2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFC7E6C4),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      color: Color(0xFF2E7D32),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "This won't take long.",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B4324),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleLoader(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Soft glowing outer backdrop
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFF1FBF0),
                  Color(0xFFDCF3DA),
                ],
                radius: 0.85,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1B5E20).withValues(alpha: 0.10),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),

          // 2. Rotating smooth green active arc
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * 3.14159,
                child: CustomPaint(
                  size: Size(size, size),
                  painter: _GoogleLoaderRingPainter(),
                ),
              );
            },
          ),

          // 3. Central white circular card with Google 4-color 'G'
          Container(
            width: size * 0.44,
            height: size * 0.44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: SizedBox(
                width: 34,
                height: 34,
                child: CustomPaint(
                  painter: GoogleLogoPainter(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleLoaderRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8.0) / 2;

    // Faint track
    final trackPaint = Paint()
      ..color = const Color(0xFFCCE8C8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6;
    canvas.drawCircle(center, radius, trackPaint);

    // Active vibrant arc
    final arcPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.2
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      4.2, // ~240 degrees sweep
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
