import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import 'app_buttons.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.isDestructive = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: () => Navigator.of(ctx).pop(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? const Color(0xFFFFEBEE)
                        : AppColors.mintSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDestructive
                        ? Icons.warning_amber_rounded
                        : Icons.help_outline_rounded,
                    color: isDestructive ? AppColors.error : AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.heading3.copyWith(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              message,
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    cancelText,
                    style: AppTypography.buttonText
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 10),
                PrimaryButton(
                  text: confirmText,
                  onPressed: onConfirm,
                  width: 110,
                  height: 44,
                  backgroundColor:
                      isDestructive ? AppColors.error : AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
