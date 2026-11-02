import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../localization/app_localizations.dart';

class PermissionService {
  PermissionService._();

  static final PermissionService instance = PermissionService._();

  /// Check whether camera permission is already granted
  Future<bool> isCameraGranted() async {
    try {
      final status = await Permission.camera.status;
      return status.isGranted;
    } catch (e) {
      debugPrint('Permission status check error: $e');
      return true; // Default fallback for web/desktop test environments
    }
  }

  /// Directly trigger the native Android/iOS camera permission prompt
  Future<bool> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('Permission request error: $e');
      return true;
    }
  }

  /// Farmer-friendly bottom sheet explaining camera usage and asking for permission at start
  Future<bool> askCameraPermissionAtStart(BuildContext context, {bool forceShow = false}) async {
    // 1. If already granted, do not disturb the user
    if (!forceShow) {
      final alreadyGranted = await isCameraGranted();
      if (alreadyGranted) {
        return true;
      }
    }

    if (!context.mounted) return false;

    final loc = AppLocalizations.of(context);
    final isMarathi = loc.language == AppLanguage.marathi;
    final isHindi = loc.language == AppLanguage.hindi;

    final title = isMarathi
        ? 'कॅमेरा परवानगी आवश्यक'
        : isHindi
            ? 'कैमरा अनुमति आवश्यक'
            : 'Camera Access Required';

    final subtitle = isMarathi
        ? 'शेतात ऊसाच्या पानांचे फोटो काढून रोगांचे अचूक निदान करण्यासाठी कॅमेरा परवानगी द्या.'
        : isHindi
            ? 'खेत में गन्ने की पत्तियों के फोटो लेकर रोगों का पता लगाने के लिए कैमरा अनुमति दें।'
            : 'CaneCare AI needs camera access to capture sugarcane leaf photos and detect diseases using AI.';

    final allowBtnText = isMarathi
        ? 'कॅमेरा सुरू करा'
        : isHindi
            ? 'कैमरा अनुमति दें'
            : 'Allow Camera Access';

    final skipBtnText = isMarathi
        ? 'नंतर द्या'
        : isHindi
            ? 'अभी नहीं'
            : 'Not Now';

    // Show stylish pre-permission bottom sheet
    final result = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.90,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x2A1B5E20),
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top decorative handle
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Camera Badge Icon with glowing leaf ring
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2E7D32), Color(0xFF14451D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGreen,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF556E5D),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Features bullet points
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F8F3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2EBDD)),
                    ),
                    child: Column(
                      children: [
                        _buildFeatureItem(
                          icon: Icons.energy_savings_leaf_rounded,
                          text: isMarathi
                              ? 'शेतात थेट पानावरील रोगांची तपासणी'
                              : isHindi
                                  ? 'खेत में सीधे रोग की पहचान'
                                  : 'Real-time leaf scanning in your farm',
                        ),
                        const SizedBox(height: 10),
                        _buildFeatureItem(
                          icon: Icons.psychology_rounded,
                          text: isMarathi
                              ? 'एआय (AI) द्वारे काही सेकंदात निकाल'
                              : isHindi
                                  ? 'एआई द्वारा तुरंत सटीक निदान'
                                  : 'Instant AI-powered disease diagnosis',
                        ),
                        const SizedBox(height: 10),
                        _buildFeatureItem(
                          icon: Icons.lock_outline_rounded,
                          text: isMarathi
                              ? 'फोटो व डेटा संपूर्ण सुरक्षित'
                              : isHindi
                                  ? 'पूरी तरह सुरक्षित और निजी'
                                  : '100% private & secure on your device',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Allow Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(sheetContext).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              allowBtnText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Skip Button
                  TextButton(
                    onPressed: () => Navigator.of(sheetContext).pop(false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(
                      skipBtnText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF708577),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // If user tapped Allow, now prompt the native system permission dialog
    if (result == true) {
      final granted = await requestCameraPermission();
      return granted;
    }

    return false;
  }

  static Widget _buildFeatureItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D4B35),
            ),
          ),
        ),
      ],
    );
  }
}
