import 'package:image_picker/image_picker.dart';

enum ImageValidationResult {
  valid,
  unsupportedType,
  imageTooLarge,
  blurryImage,
  wrongCropNotSugarcane,
  noLeafDetected,
}

abstract class ImageService {
  Future<XFile?> pickImageFromCamera();
  Future<XFile?> pickImageFromGallery();
  Future<ImageValidationResult> validateImage(String path);
}

class LocalImageService implements ImageService {
  final ImagePicker _picker = ImagePicker();
  ImageValidationResult simulatedValidationResult = ImageValidationResult.valid;
  bool simulateCameraPermissionDenied = false;

  @override
  Future<XFile?> pickImageFromCamera() async {
    if (simulateCameraPermissionDenied) {
      throw Exception('Camera permission denied.');
    }
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 90,
      );
      return file;
    } catch (e) {
      // In desktop/simulator without camera hardware, provide realistic demo sample
      return XFile('assets/images/leaf_in_viewfinder.png');
    }
  }

  @override
  Future<XFile?> pickImageFromGallery() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      return file;
    } catch (e) {
      return XFile('assets/images/disease_red_rot.png');
    }
  }

  @override
  Future<ImageValidationResult> validateImage(String path) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // If simulation flag set
    if (simulatedValidationResult != ImageValidationResult.valid) {
      return simulatedValidationResult;
    }

    // Default checks
    if (path.endsWith('.gif') || path.endsWith('.bmp')) {
      return ImageValidationResult.unsupportedType;
    }

    return ImageValidationResult.valid;
  }
}
