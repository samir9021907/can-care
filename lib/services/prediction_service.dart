import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/api_constants.dart';
import '../models/disease_info.dart';
import '../models/prediction_result.dart';
import '../models/treatment_guidance.dart';
import 'api_client.dart';

enum DemoPredictionFailure {
  none,
  noInternet,
  modelUnavailable,
  lowConfidence,
  unsupportedCrop,
  analysisFailed,
}

abstract class PredictionService {
  Stream<String> get analysisProgressStream;
  Future<PredictionResult> predictDisease({
    required String imagePath,
    DemoPredictionFailure failureMode = DemoPredictionFailure.none,
    String? preferredDiseaseId,
  });
}

class RemotePredictionService implements PredictionService {
  final ApiClient _apiClient = ApiClient();
  final DemoPredictionService _fallbackService = DemoPredictionService();
  final StreamController<String> _progressController = StreamController<String>.broadcast();

  @override
  Stream<String> get analysisProgressStream => _progressController.stream;

  DiseaseSeverity _parseSeverity(dynamic val) {
    if (val == null) return DiseaseSeverity.low;
    final str = val.toString().toLowerCase();
    if (str.contains('none') || str.contains('healthy')) return DiseaseSeverity.none;
    if (str.contains('low')) return DiseaseSeverity.low;
    if (str.contains('mod') || str.contains('medium')) return DiseaseSeverity.moderate;
    if (str.contains('crit')) return DiseaseSeverity.critical;
    if (str.contains('high')) return DiseaseSeverity.high;
    return DiseaseSeverity.low;
  }

  @override
  Future<PredictionResult> predictDisease({
    required String imagePath,
    DemoPredictionFailure failureMode = DemoPredictionFailure.none,
    String? preferredDiseaseId,
  }) async {
    try {
      _progressController.add('Optimizing sugarcane leaf sample...');
      await Future.delayed(const Duration(milliseconds: 300));

      _progressController.add('Acquiring location for nearest shop matching...');
      double? lat;
      double? lon;
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
        ).timeout(const Duration(seconds: 4));
        lat = position.latitude;
        lon = position.longitude;
      } catch (locErr) {
        debugPrint('Geolocator note: $locErr');
      }

      _progressController.add('Uploading to CaneCare AI Cloud Server...');
      final fields = <String, String>{
        'language': 'en',
      };
      if (lat != null && lon != null) {
        fields['latitude'] = lat.toString();
        fields['longitude'] = lon.toString();
      }

      final res = await _apiClient.postMultipart(
        url: ApiConstants.predict,
        filePath: imagePath,
        fields: fields,
      );

      _progressController.add('Interpreting disease symptoms & treatment...');
      await Future.delayed(const Duration(milliseconds: 300));

      final scanId = res['scan_id']?.toString() ?? 'scan_${DateTime.now().millisecondsSinceEpoch}';
      final statusStr = (res['status'] ?? 'success').toString().toLowerCase();
      final predData = res['prediction'] as Map<String, dynamic>? ?? {};
      final guidanceData = res['guidance'] as Map<String, dynamic>? ?? {};

      final label = predData['label']?.toString() ?? 'Healthy Sugarcane';
      final displayName = predData['display_name']?.toString() ?? label;
      final confidence = (predData['confidence'] as num?)?.toDouble() ?? 0.95;
      final rawSeverity = predData['severity']?.toString() ?? 'none';
      final isHealthy = statusStr == 'healthy' || label.toLowerCase().contains('healthy');

      // Guidance lists
      final symptomsList = (guidanceData['symptoms'] as List?)?.map((e) => e.toString()).toList() ?? [];
      final causesList = (guidanceData['causes'] as List?)?.map((e) => e.toString()).toList() ?? [];
      final treatmentList = (guidanceData['treatment'] as List?)?.map((e) => e.toString()).toList() ?? [];
      final preventionList = (guidanceData['prevention'] as List?)?.map((e) => e.toString()).toList() ?? [];

      // Find local disease info for multilingual and rich scientific names if available
      final localDiseases = DiseaseInfo.getSugarcaneDiseases();
      final matchedLocal = localDiseases.firstWhere(
        (d) => d.id.toLowerCase() == label.toLowerCase() ||
               d.name.toLowerCase() == label.toLowerCase() ||
               d.name.toLowerCase() == displayName.toLowerCase(),
        orElse: () => localDiseases.firstWhere(
          (d) => d.isHealthy == isHealthy,
          orElse: () => localDiseases.first,
        ),
      );

      PredictionStatus pStatus = PredictionStatus.success;
      if (isHealthy) {
        pStatus = PredictionStatus.healthy;
      } else if (confidence < 0.6) {
        pStatus = PredictionStatus.lowConfidence;
      }

      return PredictionResult(
        id: scanId,
        diseaseName: displayName.isNotEmpty ? displayName : matchedLocal.name,
        scientificName: matchedLocal.scientificName.isNotEmpty ? matchedLocal.scientificName : 'Saccharum officinarum',
        marathiName: matchedLocal.marathiName.isNotEmpty ? matchedLocal.marathiName : displayName,
        hindiName: matchedLocal.hindiName.isNotEmpty ? matchedLocal.hindiName : displayName,
        confidenceScore: confidence,
        severity: _parseSeverity(rawSeverity),
        symptoms: symptomsList.isNotEmpty ? symptomsList : matchedLocal.symptoms,
        causes: causesList.isNotEmpty ? causesList : matchedLocal.causes,
        treatment: TreatmentGuidance(
          culturalPractices: treatmentList.isNotEmpty ? treatmentList : matchedLocal.treatment.culturalPractices,
          culturalPracticesMarathi: matchedLocal.treatment.culturalPracticesMarathi,
          culturalPracticesHindi: matchedLocal.treatment.culturalPracticesHindi,
          organicMeasures: matchedLocal.treatment.organicMeasures,
          organicMeasuresMarathi: matchedLocal.treatment.organicMeasuresMarathi,
          organicMeasuresHindi: matchedLocal.treatment.organicMeasuresHindi,
          generalPreventiveSteps: preventionList.isNotEmpty ? preventionList : matchedLocal.treatment.generalPreventiveSteps,
          generalPreventiveStepsMarathi: matchedLocal.treatment.generalPreventiveStepsMarathi,
          generalPreventiveStepsHindi: matchedLocal.treatment.generalPreventiveStepsHindi,
          expertAdvisoryNote: matchedLocal.treatment.expertAdvisoryNote,
          expertAdvisoryNoteMarathi: matchedLocal.treatment.expertAdvisoryNoteMarathi,
          expertAdvisoryNoteHindi: matchedLocal.treatment.expertAdvisoryNoteHindi,
        ),
        imagePath: imagePath,
        isDemo: false,
        status: pStatus,
        analyzedAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Remote prediction failed: $e, using local demo fallback');
      return _fallbackService.predictDisease(
        imagePath: imagePath,
        failureMode: failureMode,
        preferredDiseaseId: preferredDiseaseId,
      );
    }
  }
}

class DemoPredictionService implements PredictionService {
  @override
  Stream<String> get analysisProgressStream async* {
    yield 'Preprocessing sugarcane leaf image...';
    await Future.delayed(const Duration(milliseconds: 650));
    yield 'Segmenting lamina and midrib regions...';
    await Future.delayed(const Duration(milliseconds: 700));
    yield 'Extracting visual symptom patterns...';
    await Future.delayed(const Duration(milliseconds: 750));
    yield 'Running diagnostic demo classifier...';
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Future<PredictionResult> predictDisease({
    required String imagePath,
    DemoPredictionFailure failureMode = DemoPredictionFailure.none,
    String? preferredDiseaseId,
  }) async {
    // Artificial pipeline simulation delay
    await Future.delayed(const Duration(milliseconds: 2700));

    if (failureMode == DemoPredictionFailure.noInternet) {
      throw Exception('No internet connection. Please verify your mobile data or Wi-Fi.');
    }
    if (failureMode == DemoPredictionFailure.modelUnavailable) {
      throw Exception('AI Prediction server is temporarily offline for maintenance.');
    }
    if (failureMode == DemoPredictionFailure.analysisFailed) {
      throw Exception('Unable to process leaf image due to an unexpected parsing error.');
    }
    if (failureMode == DemoPredictionFailure.lowConfidence) {
      return PredictionResult.mockLowConfidence(imagePath: imagePath);
    }
    if (failureMode == DemoPredictionFailure.unsupportedCrop) {
      final healthy = DiseaseInfo.getSugarcaneDiseases().first;
      return PredictionResult(
        id: 'unsupported_${DateTime.now().millisecondsSinceEpoch}',
        diseaseName: 'Unsupported Crop / Non-Sugarcane Foliage',
        scientificName: 'Non-Saccharum Species',
        marathiName: 'उसाचे पान नाही / इतर पीक',
        hindiName: 'गन्ने की पत्ती नहीं / अन्य फसल',
        confidenceScore: 0.25,
        severity: DiseaseSeverity.none,
        symptoms: [
          'Morphological leaf venation does not match standard sugarcane anatomy',
          'Vein spacing and blade contours suggest another crop or weed',
        ],
        causes: ['Camera focused on non-sugarcane plant or intercrop'],
        treatment: healthy.treatment,
        imagePath: imagePath,
        isDemo: true,
        status: PredictionStatus.unsupportedCrop,
        analyzedAt: DateTime.now(),
      );
    }

    final diseases = DiseaseInfo.getSugarcaneDiseases();
    DiseaseInfo selected;
    if (preferredDiseaseId != null) {
      selected = diseases.firstWhere(
        (d) => d.id == preferredDiseaseId,
        orElse: () => diseases[2], // Rust
      );
    } else {
      selected = diseases[2]; // Default demo Rust
    }

    return PredictionResult.fromDisease(
      selected,
      imagePath: imagePath,
      confidence: selected.isHealthy ? 0.984 : 0.938,
      status: selected.isHealthy
          ? PredictionStatus.healthy
          : PredictionStatus.success,
    );
  }
}
