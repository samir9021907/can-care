import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Reusable input field matching the CaneCare AI authentication reference board.
/// Renders a white container with subtle light-green borders (#D4DEC9),
/// prefix icon, optional suffix icon, and dedicated inline error message in red (#E53935).
class AuthTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixWidget;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorMessage;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool hasError;
  final bool autofocus;

  const AuthTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixWidget,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorMessage,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.hasError = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final isError = hasError || (errorMessage != null && errorMessage!.isNotEmpty);
    final borderColor = isError ? AppColors.error : AppColors.inputBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: isError ? 1.4 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              if (prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 10),
                  child: Icon(
                    prefixIcon,
                    color: isError ? AppColors.error : const Color(0xFF6B8A73),
                    size: 20,
                  ),
                )
              else
                const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  onTap: onTap,
                  readOnly: readOnly,
                  autofocus: autofocus,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94A89A),
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              if (suffixWidget != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: suffixWidget!,
                )
              else if (isError)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 19,
                  ),
                ),
            ],
          ),
        ),
        if (isError && errorMessage != null && errorMessage!.isNotEmpty) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorMessage!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
