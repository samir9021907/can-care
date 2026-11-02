import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Primary deep-green rounded button matching the CaneCare AI reference specification.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingText;
  final IconData? trailingIcon;
  final IconData? leadingIcon;
  final double height;
  final Color? backgroundColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.loadingText,
    this.trailingIcon,
    this.leadingIcon,
    this.height = 52,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.primary;
    final isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: bgColor.withValues(alpha: 0.65),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.85),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  if (loadingText != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      loadingText!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(trailingIcon, size: 20, color: Colors.white),
                  ],
                ],
              ),
      ),
    );
  }
}
