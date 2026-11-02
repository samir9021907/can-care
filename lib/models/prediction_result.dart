import '../localization/app_localizations.dart';
import 'disease_info.dart';
import 'treatment_guidance.dart';

enum PredictionStatus {
  success,
  healthy,
  lowConfidence,
  uncertain,
  unsupportedCrop,
  wrongCrop,
  failed,
}

class PredictionResult {
  final String id;
  final String diseaseName;
  final String scientificName;
  final String marathiName;
  final String hindiName;
  final double confidenceScore; // 0.0 to 1.0 (Demo score)
  final DiseaseSeverity severity;
  final List<String> symptoms;
  final List<String> causes;
  final TreatmentGuidance treatment;
  final String? imagePath;
  final bool isDemo;
  final PredictionStatus status;
  final DateTime analyzedAt;
  final bool hasAffectedAreaOverlay;

  const PredictionResult({
    required this.id,
    required this.diseaseName,
    required this.scientificName,
    required this.marathiName,
    required this.hindiName,
    required this.confidenceScore,
    required this.severity,
    required this.symptoms,
    required this.causes,
    required this.treatment,
    this.imagePath,
    this.isDemo = true,
    this.status = PredictionStatus.success,
    required this.analyzedAt,
    this.hasAffectedAreaOverlay = false,
  });

  bool get isHealthy => status == PredictionStatus.healthy;
  bool get isLowConfidence => status == PredictionStatus.lowConfidence;
  bool get isUncertain => status == PredictionStatus.uncertain;
  bool get isUnsupportedCrop => status == PredictionStatus.unsupportedCrop;

  String get confidencePercentage =>
      '${(confidenceScore * 100).toStringAsFixed(1)}%';

  String getLocalizedName(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.marathi:
        return marathiName.isNotEmpty ? marathiName : diseaseName;
      case AppLanguage.hindi:
        return hindiName.isNotEmpty ? hindiName : diseaseName;
      case AppLanguage.english:
        return diseaseName;
    }
  }

  PredictionResult copyWith({
    bool? hasAffectedAreaOverlay,
  }) {
    return PredictionResult(
      id: id,
      diseaseName: diseaseName,
      scientificName: scientificName,
      marathiName: marathiName,
      hindiName: hindiName,
      confidenceScore: confidenceScore,
      severity: severity,
      symptoms: symptoms,
      causes: causes,
      treatment: treatment,
      imagePath: imagePath,
      isDemo: isDemo,
      status: status,
      analyzedAt: analyzedAt,
      hasAffectedAreaOverlay:
          hasAffectedAreaOverlay ?? this.hasAffectedAreaOverlay,
    );
  }

  static PredictionResult fromDisease(
    DiseaseInfo disease, {
    String? imagePath,
    double confidence = 0.942,
    PredictionStatus status = PredictionStatus.success,
  }) {
    return PredictionResult(
      id: 'scan_${DateTime.now().millisecondsSinceEpoch}',
      diseaseName: disease.name,
      scientificName: disease.scientificName,
      marathiName: disease.marathiName,
      hindiName: disease.hindiName,
      confidenceScore: confidence,
      severity: disease.typicalSeverity,
      symptoms: disease.symptoms,
      causes: disease.causes,
      treatment: disease.treatment,
      imagePath: imagePath,
      isDemo: true,
      status: disease.isHealthy ? PredictionStatus.healthy : status,
      analyzedAt: DateTime.now(),
      hasAffectedAreaOverlay: false,
    );
  }

  static PredictionResult mockLowConfidence({String? imagePath}) {
    return PredictionResult(
      id: 'scan_low_conf_${DateTime.now().millisecondsSinceEpoch}',
      diseaseName: 'Uncertain: Possible Sugarcane Rust',
      scientificName: 'Puccinia melanocephala (Inconclusive)',
      marathiName: 'संभाव्य तांबेरा (कमी खात्री)',
      hindiName: 'संभावित रतुआ (अनिश्चित)',
      confidenceScore: 0.428,
      severity: DiseaseSeverity.low,
      symptoms: [
        'Visible discoloration matches early rust flecking or heat stress',
        'Image quality or lighting makes definitive classification uncertain',
      ],
      causes: [
        'Sub-optimal lighting or multiple overlapping leaf surfaces',
        'Early-stage symptoms sharing characteristics with nutrient deficiency',
      ],
      treatment: TreatmentGuidance(
        culturalPractices: [
          'Take another high-resolution photo in bright, indirect daylight',
          'Isolate affected plant for close manual inspection',
        ],
        organicMeasures: [
          'Spray neem formulation as preventive deterrent',
        ],
        generalPreventiveSteps: [
          'Re-scan in 48 hours to observe symptom progression',
          'Contact local KVK extension officer with physical leaf sample',
        ],
      ),
      imagePath: imagePath,
      isDemo: true,
      status: PredictionStatus.lowConfidence,
      analyzedAt: DateTime.now(),
      hasAffectedAreaOverlay: false,
    );
  }
}
