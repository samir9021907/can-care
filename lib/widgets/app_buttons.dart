import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = AppDimensions.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    final bg = backgroundColor ?? AppColors.primary;
    final fg = textColor ?? Colors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: height.clamp(AppDimensions.minTouchTarget, 100),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg.withValues(alpha: 0.4),
          disabledForegroundColor: fg.withValues(alpha: 0.6),
          elevation: isEnabled ? 2 : 0,
          shadowColor: bg.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(fg),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: fg),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style: AppTypography.buttonText.copyWith(color: fg),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double height;
  final Color? borderColor;
  final Color? textColor;
  final Color? backgroundColor;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.height = AppDimensions.buttonHeight,
    this.borderColor,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final fg = textColor ?? AppColors.darkGreen;
    final bg = backgroundColor ?? AppColors.mintSurface;
    final border = borderColor ?? AppColors.primary.withValues(alpha: 0.3);

    return SizedBox(
      width: width ?? double.infinity,
      height: height.clamp(AppDimensions.minTouchTarget, 100),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          side: BorderSide(color: border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: fg),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text,
                style: AppTypography.buttonText.copyWith(color: fg),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
