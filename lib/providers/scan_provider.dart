import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/prediction_result.dart';
import '../models/scan_report.dart';
import '../services/image_service.dart';
import '../services/prediction_service.dart';
import '../services/report_service.dart';

enum CameraPermissionStatus {
  granted,
  denied,
  restricted,
  initializationFailed,
}

class ScanProvider extends ChangeNotifier {
  final ImageService _imageService;
  final PredictionService _predictionService;
  final ReportService _reportService;

  XFile? _selectedImage;
  Uint8List? _imageBytes;
  String? _imagePath;
  bool _isFlashOn = false;
  CameraPermissionStatus _cameraPermission = CameraPermissionStatus.granted;

  // Validation States
  bool _isValidating = false;
  ImageValidationResult _validationResult = ImageValidationResult.valid;
  String? _validationErrorMessage;

  // AI Analysis States
  bool _isAnalyzing = false;
  String _analysisStatusMessage = 'Initializing vision pipeline...';
  PredictionResult? _predictionResult;
  String? _analysisError;
  DemoPredictionFailure _simulatedFailure = DemoPredictionFailure.none;
  String? _selectedSimulationDiseaseId; // Allows user to test different disease results

  // Report Save States
  bool _isSavingReport = false;
  bool _reportSavedSuccess = false;
  String? _saveReportError;

  // Share States
  bool _isSharing = false;
  bool _shareError = false;

  ScanProvider({
    ImageService? imageService,
    PredictionService? predictionService,
    ReportService? reportService,
  })  : _imageService = imageService ?? LocalImageService(),
        _predictionService = predictionService ?? DemoPredictionService(),
        _reportService = reportService ?? LocalReportService();

  XFile? get selectedImage => _selectedImage;
  Uint8List? get imageBytes => _imageBytes;
  String get imagePath => _imagePath ?? 'assets/images/leaf_in_viewfinder.png';
  bool get isFlashOn => _isFlashOn;
  CameraPermissionStatus get cameraPermission => _cameraPermission;

  bool get isValidating => _isValidating;
  ImageValidationResult get validationResult => _validationResult;
  String? get validationErrorMessage => _validationErrorMessage;

  bool get isAnalyzing => _isAnalyzing;
  String get analysisStatusMessage => _analysisStatusMessage;
  PredictionResult? get predictionResult => _predictionResult;
  String? get analysisError => _analysisError;
  DemoPredictionFailure get simulatedFailure => _simulatedFailure;

  bool get isSavingReport => _isSavingReport;
  bool get reportSavedSuccess => _reportSavedSuccess;
  String? get saveReportError => _saveReportError;

  bool get isSharing => _isSharing;
  bool get shareError => _shareError;

  void toggleFlash() {
    _isFlashOn = !_isFlashOn;
    notifyListeners();
  }

  void setCameraPermission(CameraPermissionStatus status) {
    _cameraPermission = status;
    notifyListeners();
  }

  void setSimulatedFailure(DemoPredictionFailure failure) {
    _simulatedFailure = failure;
    notifyListeners();
  }

  void setSelectedSimulationDisease(String? diseaseId) {
    _selectedSimulationDiseaseId = diseaseId;
    notifyListeners();
  }

  Future<void> captureImage() async {
    _validationErrorMessage = null;
    _analysisError = null;

    if (_cameraPermission == CameraPermissionStatus.denied) {
      notifyListeners();
      return;
    }

    try {
      final file = await _imageService.pickImageFromCamera();
      if (file != null) {
        _selectedImage = file;
        _imagePath = file.path;
        try {
          _imageBytes = await file.readAsBytes();
        } catch (_) {
          _imageBytes = null;
        }
        notifyListeners();
        await _validateCurrentImage();
      }
    } catch (e) {
      _validationErrorMessage = 'Camera initialization failed: ${e.toString()}';
      _cameraPermission = CameraPermissionStatus.initializationFailed;
      notifyListeners();
    }
  }

  Future<void> onImageCaptured(XFile file) async {
    _validationErrorMessage = null;
    _analysisError = null;
    _selectedImage = file;
    _imagePath = file.path;
    try {
      _imageBytes = await file.readAsBytes();
    } catch (_) {
      _imageBytes = null;
    }
    notifyListeners();
    await _validateCurrentImage();
  }

  Future<void> pickFromGallery() async {
    _validationErrorMessage = null;
    _analysisError = null;

    try {
      final file = await _imageService.pickImageFromGallery();
      if (file != null) {
        _selectedImage = file;
        _imagePath = file.path;
        try {
          _imageBytes = await file.readAsBytes();
        } catch (_) {
          _imageBytes = null;
        }
        notifyListeners();
        await _validateCurrentImage();
      }
    } catch (e) {
      _validationErrorMessage = 'Failed to load image from gallery: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> setDemoLeafImage(String assetPath, {ImageValidationResult validation = ImageValidationResult.valid}) async {
    _selectedImage = XFile(assetPath);
    _imageBytes = null;
    _imagePath = assetPath;
    _validationResult = validation;
    _validationErrorMessage = null;
    notifyListeners();
  }

  Future<void> _validateCurrentImage() async {
    if (_imagePath == null) return;
    _isValidating = true;
    notifyListeners();

    _validationResult = await _imageService.validateImage(_imagePath!);
    _isValidating = false;

    if (_validationResult == ImageValidationResult.imageTooLarge) {
      _validationErrorMessage =
          'Image size exceeds 10MB limit. Please capture a lower resolution photo.';
    } else if (_validationResult == ImageValidationResult.unsupportedType) {
      _validationErrorMessage =
          'Unsupported format. Please select JPEG, JPG, or PNG leaf photos.';
    } else if (_validationResult == ImageValidationResult.blurryImage) {
      _validationErrorMessage =
          'Image appears blurry or out of focus. Hold phone steady in good light.';
    } else if (_validationResult == ImageValidationResult.noLeafDetected) {
      _validationErrorMessage =
          'No sugarcane leaf detected in photo frame. Center the leaf clearly.';
    } else if (_validationResult == ImageValidationResult.wrongCropNotSugarcane) {
      _validationErrorMessage =
          'Leaf does not resemble sugarcane foliage. Please scan a sugarcane leaf.';
    } else {
      _validationErrorMessage = null;
    }
    notifyListeners();
  }

  Future<void> startAnalysis() async {
    if (_imagePath == null) return;

    _isAnalyzing = true;
    _analysisError = null;
    _predictionResult = null;
    _reportSavedSuccess = false;
    _saveReportError = null;
    notifyListeners();

    // Stream status messages
    _predictionService.analysisProgressStream.listen((msg) {
      if (_isAnalyzing) {
        _analysisStatusMessage = msg;
        notifyListeners();
      }
    });

    try {
      final result = await _predictionService.predictDisease(
        imagePath: _imagePath!,
        failureMode: _simulatedFailure,
        preferredDiseaseId: _selectedSimulationDiseaseId,
      );
      _predictionResult = result;
      _isAnalyzing = false;
      notifyListeners();
    } catch (e) {
      _analysisError = e.toString().replaceAll('Exception: ', '');
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  void toggleAffectedOverlay() {
    if (_predictionResult != null) {
      _predictionResult = _predictionResult!.copyWith(
        hasAffectedAreaOverlay: !_predictionResult!.hasAffectedAreaOverlay,
      );
      notifyListeners();
    }
  }

  Future<bool> saveCurrentReport({String fieldNotes = ''}) async {
    if (_predictionResult == null) return false;

    _isSavingReport = true;
    _saveReportError = null;
    notifyListeners();

    try {
      final report = ScanReport.fromPrediction(
        _predictionResult!,
        notes: fieldNotes,
      );
      await _reportService.saveReport(report);
      _isSavingReport = false;
      _reportSavedSuccess = true;
      notifyListeners();
      return true;
    } catch (e) {
      _isSavingReport = false;
      _saveReportError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> shareCurrentReport({bool simulateError = false}) async {
    _isSharing = true;
    _shareError = false;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    if (simulateError) {
      _isSharing = false;
      _shareError = true;
      notifyListeners();
      return;
    }

    _isSharing = false;
    notifyListeners();
  }

  void resetScan() {
    _selectedImage = null;
    _imageBytes = null;
    _imagePath = 'assets/images/onboarding_preview.png';
    _isAnalyzing = false;
    _analysisError = null;
    _predictionResult = null;
    _validationResult = ImageValidationResult.valid;
    _validationErrorMessage = null;
    _reportSavedSuccess = false;
    _saveReportError = null;
    _shareError = false;
    notifyListeners();
  }
}
