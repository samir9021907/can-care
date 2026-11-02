import '../models/disease_info.dart';
import '../models/prediction_result.dart';

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
