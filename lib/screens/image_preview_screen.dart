import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../localization/app_localizations.dart';
import '../providers/scan_provider.dart';
import '../services/image_service.dart';
import 'ai_analyzing_screen.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final scan = context.watch<ScanProvider>();
    final hasValidationError =
        scan.validationResult != ImageValidationResult.valid;

    final String imagePath = scan.imagePath;
    final bool isAsset = imagePath.startsWith('assets/');

    String displayFileName = 'Leaf image.jpg';
    String displayFileSize = '(2.4 MB)';

    if (scan.imageBytes != null && scan.imageBytes!.isNotEmpty) {
      final bytesLen = scan.imageBytes!.length;
      if (bytesLen < 1024 * 1024) {
        displayFileSize = '(${(bytesLen / 1024).toStringAsFixed(1)} KB)';
      } else {
        displayFileSize = '(${(bytesLen / (1024 * 1024)).toStringAsFixed(1)} MB)';
      }
      final rawName = scan.selectedImage?.name;
      if (rawName != null && rawName.isNotEmpty && !rawName.startsWith('blob:')) {
        displayFileName = rawName;
      } else {
        displayFileName = 'Sugarcane_leaf_sample.jpg';
      }
    } else if (isAsset) {
      displayFileName = imagePath.split('/').last;
      displayFileSize = '(1.8 MB)';
    } else if (!kIsWeb) {
      try {
        final localFile = File(imagePath);
        if (localFile.existsSync()) {
          displayFileName = localFile.path.split(RegExp(r'[/\\]')).last;
          final bytes = localFile.lengthSync();
          if (bytes < 1024 * 1024) {
            displayFileSize = '(${(bytes / 1024).toStringAsFixed(1)} KB)';
          } else {
            displayFileSize = '(${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB)';
          }
        }
      } catch (_) {}
    } else {
      displayFileName = 'Sugarcane_leaf_sample.jpg';
      displayFileSize = '(2.1 MB)';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF14451D)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF14451D)),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                builder: (ctx) => SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFF14451D)),
                          title: Text(loc.translate('retake')),
                          onTap: () {
                            Navigator.pop(ctx);
                            scan.captureImage();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.info_outline, color: Color(0xFF14451D)),
                          title: const Text('Image File Information'),
                          subtitle: Text(displayFileName),
                          onTap: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Leaf Image Card matching Screen 6
              Container(
                width: double.infinity,
                height: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _buildLeafPreviewImage(scan, imagePath, isAsset),
                ),
              ),
              const SizedBox(height: 18),

              // Title and Size matching Screen 6
              Text(
                displayFileName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14451D),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                displayFileSize,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7E9284),
                ),
              ),
              const SizedBox(height: 24),

              // Validation Warning Banner if error simulated
              if (hasValidationError) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFB74D)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Color(0xFFE65100), size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          scan.validationErrorMessage ??
                              'Image quality issue detected.',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Retake Button (White with border)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () async {
                    await scan.captureImage();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF14451D),
                    side: const BorderSide(color: Color(0xFFD6E3D7), width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    loc.translate('retake'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Analyze Leaf Button (Big forest green button)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AiAnalyzingScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    loc.translate('analyze_leaf'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Subtext: "Make sure the leaf is clear and well-lit."
              Text(
                loc.translate('preview_subtext'),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7E9284),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeafPreviewImage(ScanProvider scan, String imagePath, bool isAsset) {
    if (scan.imageBytes != null && scan.imageBytes!.isNotEmpty) {
      return Image.memory(
        scan.imageBytes!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    if (isAsset) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    if (kIsWeb) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    try {
      final localFile = File(imagePath);
      if (localFile.existsSync()) {
        return Image.file(
          localFile,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      }
    } catch (_) {}

    return Image.asset(
      'assets/images/leaf_in_viewfinder.png',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.mintSurface,
      child: const Center(
        child: Icon(Icons.eco, color: AppColors.primary, size: 64),
      ),
    );
  }
}

