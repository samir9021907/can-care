import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Password input field with lock prefix and show/hide eye toggle matching Phone 2
class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final String? errorMessage;
  final bool hasError;

  const PasswordField({
    super.key,
    this.controller,
    this.hintText = 'Password',
    this.onChanged,
    this.errorMessage,
    this.hasError = false,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isError = widget.hasError ||
        (widget.errorMessage != null && widget.errorMessage!.isNotEmpty);
    final borderColor = isError ? AppColors.error : AppColors.inputBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
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
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: isError ? AppColors.error : const Color(0xFF6B8A73),
                  size: 20,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  obscureText: _obscureText,
                  onChanged: widget.onChanged,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
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
              IconButton(
                splashRadius: 18,
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF7E9284),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ],
          ),
        ),
        if (isError && widget.errorMessage != null) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              widget.errorMessage!,
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
