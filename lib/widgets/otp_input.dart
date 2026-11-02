import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

/// 6-digit OTP Input widget matching the CaneCare AI design specification.
/// Supports auto-focus advance, backspace navigation, paste handling, and error states.
class OtpInputWidget extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool hasError;
  final String? errorMessage;

  const OtpInputWidget({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
    this.hasError = false,
    this.errorMessage,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentOtp => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      // Handle paste of full code
      final clean = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < widget.length && i < clean.length; i++) {
        _controllers[i].text = clean[i];
      }
      final lastIdx = clean.length < widget.length ? clean.length : widget.length - 1;
      _focusNodes[lastIdx].requestFocus();
      widget.onChanged?.call(_currentOtp);
      if (_currentOtp.length == widget.length) {
        widget.onCompleted(_currentOtp);
      }
      setState(() {});
      return;
    }

    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    widget.onChanged?.call(_currentOtp);
    if (_currentOtp.length == widget.length) {
      widget.onCompleted(_currentOtp);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isError = widget.hasError ||
        (widget.errorMessage != null && widget.errorMessage!.isNotEmpty);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(widget.length, (index) {
            final isFocused = _focusNodes[index].hasFocus;
            final hasValue = _controllers[index].text.isNotEmpty;

            Color borderColor;
            if (isError) {
              borderColor = AppColors.error;
            } else if (isFocused) {
              borderColor = AppColors.primary;
            } else if (hasValue) {
              borderColor = AppColors.darkGreen;
            } else {
              borderColor = AppColors.inputBorder;
            }

            return Container(
              width: 48,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor,
                  width: (isFocused || isError) ? 1.8 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) {
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.backspace &&
                      _controllers[index].text.isEmpty &&
                      index > 0) {
                    _focusNodes[index - 1].requestFocus();
                    _controllers[index - 1].clear();
                    setState(() {});
                  }
                },
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isError ? AppColors.error : AppColors.darkGreen,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (val) => _onDigitChanged(index, val),
                ),
              ),
            );
          }),
        ),
        if (isError && widget.errorMessage != null) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 16,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  widget.errorMessage!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
