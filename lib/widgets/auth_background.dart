import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'leaf_decoration.dart';

/// Reusable decorative authentication background matching the CaneCare AI reference specification.
/// Features:
/// - Soft pale-green background (#F7FAF5)
/// - Cream-colored decorative glow circle in upper-right corner (#F2EDC9)
/// - Watercolor sugarcane leaf illustrations at the lower corners
class AuthBackground extends StatelessWidget {
  final Widget child;
  final bool showBottomLeaves;
  final bool showTopCreamCircle;

  const AuthBackground({
    super.key,
    required this.child,
    this.showBottomLeaves = true,
    this.showTopCreamCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Soft Cream-colored decorative circle in the upper-right corner
          if (showTopCreamCircle)
            Positioned(
              top: -50,
              right: -50,
              child: IgnorePointer(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.cream.withValues(alpha: 0.85),
                        AppColors.cream.withValues(alpha: 0.35),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.65, 1.0],
                    ),
                  ),
                ),
              ),
            ),

          // 2. Subtle light-green sugarcane leaf illustrations at the lower corners
          if (showBottomLeaves)
            const LeafDecorationBackground(height: 150),

          // 3. Foreground Screen Content
          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}
