import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final String? errorText;
  final String? helperText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool isRequired;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.errorText,
    this.helperText,
    this.validator,
    this.onChanged,
    this.isRequired = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: AppTypography.titleLarge.copyWith(
                fontSize: 14,
                color: AppColors.textMain,
              ),
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          style: AppTypography.bodyLarge.copyWith(color: AppColors.textMain),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle:
                AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
            errorText: widget.errorText,
            helperText: widget.helperText,
            helperStyle:
                AppTypography.caption.copyWith(color: AppColors.textSecondary),
            errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.primary, size: 20)
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              borderSide: const BorderSide(color: AppColors.border, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              borderSide: const BorderSide(color: AppColors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
