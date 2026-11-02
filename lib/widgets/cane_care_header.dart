import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'cane_logo.dart';

/// Centered CaneCare AI brand mark and application name matching the reference boards.
class CaneCareBrandHeader extends StatelessWidget {
  final double logoSize;
  final double spacing;
  final bool compact;

  const CaneCareBrandHeader({
    super.key,
    this.logoSize = 64,
    this.spacing = 10,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CaneLogo(
          size: logoSize,
          backgroundColor: AppColors.primary,
        ),
        SizedBox(height: spacing),
        const Text(
          'CaneCare AI',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGreen,
            letterSpacing: -0.3,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
