import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum ErrorCategory {
  noLeafDetected,
  blurryImage,
  lowConfidence,
  noInternet,
  uploadFailed,
  analysisFailed,
  noSearchResults,
  serverUnavailable,
  authExpired,
  permissionDenied,
  unexpected,
}

class ErrorStateView extends StatelessWidget {
  final ErrorCategory category;
  final String? customTitle;
  final String? customMessage;
  final VoidCallback? onRetry;
  final String? retryButtonText;

  const ErrorStateView({
    super.key,
    this.category = ErrorCategory.unexpected,
    this.customTitle,
    this.customMessage,
    this.onRetry,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String title;
    String message;
    String buttonText;
    Color iconColor;
    Color iconBgColor;

    switch (category) {
      case ErrorCategory.noLeafDetected:
        icon = Icons.crop_free_rounded;
        title = 'No leaf detected';
        message = 'No leaf detected. Please capture a clear sugarcane leaf image.';
        buttonText = 'Try Again';
        iconColor = const Color(0xFFD32F2F);
        iconBgColor = const Color(0xFFFFEBEE);
        break;
      case ErrorCategory.blurryImage:
        icon = Icons.camera_alt_outlined;
        title = 'Blurry image';
        message = 'The image is unclear. Try taking the photo in better light.';
        buttonText = 'Retake Photo';
        iconColor = const Color(0xFFD32F2F);
        iconBgColor = const Color(0xFFFFEBEE);
        break;
      case ErrorCategory.lowConfidence:
        icon = Icons.warning_amber_rounded;
        title = 'Low confidence';
        message = 'We could not confidently identify the condition.';
        buttonText = 'Try Another Image';
        iconColor = const Color(0xFFF57C00);
        iconBgColor = const Color(0xFFFFF3E0);
        break;
      case ErrorCategory.noInternet:
        icon = Icons.wifi_off_rounded;
        title = 'No internet';
        message = 'You appear to be offline.';
        buttonText = 'Retry';
        iconColor = const Color(0xFFD32F2F);
        iconBgColor = const Color(0xFFFFEBEE);
        break;
      case ErrorCategory.uploadFailed:
        icon = Icons.image_not_supported_outlined;
        title = 'Upload failed';
        message = 'We could not load this image.';
        buttonText = 'Choose Another Image';
        iconColor = const Color(0xFFD32F2F);
        iconBgColor = const Color(0xFFFFEBEE);
        break;
      case ErrorCategory.analysisFailed:
        icon = Icons.error_outline_rounded;
        title = 'Analysis failed';
        message = 'Analysis could not be completed.';
        buttonText = 'Try Again';
        iconColor = const Color(0xFFD32F2F);
        iconBgColor = const Color(0xFFFFEBEE);
        break;
      case ErrorCategory.noSearchResults:
        icon = Icons.search_off_rounded;
        title = 'No search results';
        message = 'No matching diseases found.';
        buttonText = 'Try Again';
        iconColor = const Color(0xFFD32F2F);
        iconBgColor = const Color(0xFFFFEBEE);
        break;
      case ErrorCategory.serverUnavailable:
        icon = Icons.cloud_off_rounded;
        title = 'Server Unavailable';
        message = 'Our AI service is temporarily undergoing maintenance. Please retry shortly.';
        buttonText = 'Try Again';
        iconColor = const Color(0xFFF57C00);
        iconBgColor = const Color(0xFFFFF3E0);
        break;
      case ErrorCategory.authExpired:
        icon = Icons.lock_clock_outlined;
        title = 'Session Expired';
        message = 'Your session has timed out. Please sign in again to continue.';
        buttonText = 'Sign In';
        iconColor = const Color(0xFFF57C00);
        iconBgColor = const Color(0xFFFFF3E0);
        break;
      case ErrorCategory.permissionDenied:
        icon = Icons.camera_alt_outlined;
        title = 'Camera Permission Required';
        message = 'CaneCare AI needs camera access to capture sugarcane leaves.';
        buttonText = 'Grant Permission';
        iconColor = AppColors.primary;
        iconBgColor = const Color(0xFFE8F5E9);
        break;
      case ErrorCategory.unexpected:
        icon = Icons.error_outline_rounded;
        title = 'Something Went Wrong';
        message = 'An unexpected error occurred while processing your request. Please try again.';
        buttonText = 'Try Again';
        iconColor = const Color(0xFFD32F2F);
        iconBgColor = const Color(0xFFFFEBEE);
        break;
    }

    final effectiveTitle = customTitle ?? title;
    final effectiveMessage = customMessage ?? message;
    final effectiveButton = retryButtonText ?? buttonText;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 340),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E6DC), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 26, color: iconColor),
              ),
              const SizedBox(height: 14),
              Text(
                effectiveTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14451D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                effectiveMessage,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF5A7262),
                  height: 1.35,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF165228),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(
                      effectiveButton,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
