import '../localization/app_localizations.dart';
import 'disease_info.dart';
export 'disease_info.dart';
import 'prediction_result.dart';

class ScanReport {
  final String id;
  final String title;
  final String diseaseName;
  final String scientificName;
  final String marathiName;
  final String hindiName;
  final double confidenceScore;
  final DiseaseSeverity severity;
  final DateTime scanDate;
  final String? imagePath;
  final bool isHealthy;
  final bool isLowConfidence;
  final List<String> symptoms;
  final List<String> treatments;
  final String fieldNotes;
  final bool isSavedLocally;

  const ScanReport({
    required this.id,
    required this.title,
    required this.diseaseName,
    required this.scientificName,
    required this.marathiName,
    this.hindiName = '',
    required this.confidenceScore,
    required this.severity,
    required this.scanDate,
    this.imagePath,
    this.isHealthy = false,
    this.isLowConfidence = false,
    required this.symptoms,
    required this.treatments,
    this.fieldNotes = '',
    this.isSavedLocally = true,
  });

  String get confidenceDisplay =>
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

  static ScanReport fromPrediction(PredictionResult prediction,
      {String notes = ''}) {
    return ScanReport(
      id: prediction.id,
      title: prediction.diseaseName,
      diseaseName: prediction.diseaseName,
      scientificName: prediction.scientificName,
      marathiName: prediction.marathiName,
      hindiName: prediction.hindiName,
      confidenceScore: prediction.confidenceScore,
      severity: prediction.severity,
      scanDate: prediction.analyzedAt,
      imagePath: prediction.imagePath,
      isHealthy: prediction.isHealthy,
      isLowConfidence: prediction.isLowConfidence,
      symptoms: prediction.symptoms,
      treatments: prediction.treatment.culturalPractices +
          prediction.treatment.organicMeasures,
      fieldNotes: notes,
      isSavedLocally: true,
    );
  }

  static List<ScanReport> mockHistory() {
    return [
      ScanReport(
        id: 'rep_001',
        title: 'Yellow Leaf Disease',
        diseaseName: 'Yellow Leaf Disease',
        scientificName: 'Sugarcane yellow leaf virus (SCYLV)',
        marathiName: 'पिवळा पान रोग (YLD)',
        confidenceScore: 0.94,
        severity: DiseaseSeverity.moderate,
        scanDate: DateTime(2025, 4, 20, 10, 24),
        imagePath: 'assets/images/disease_yellow_leaf.png',
        isHealthy: false,
        symptoms: [
          'Prominent yellowing of midrib on 3rd to 5th leaf from top',
          'Gradual yellowing spreads to lamina',
        ],
        treatments: [
          'Manage aphid vectors with sticky traps',
          'Plant tissue culture certified plantlets',
        ],
        fieldNotes: 'Plot #2 (Satara)',
        isSavedLocally: true,
      ),
      ScanReport(
        id: 'rep_002',
        title: 'Healthy Sugarcane Leaf',
        diseaseName: 'Healthy Sugarcane Leaf',
        scientificName: 'Saccharum officinarum',
        marathiName: 'निरोगी ऊस पान',
        confidenceScore: 0.98,
        severity: DiseaseSeverity.none,
        scanDate: DateTime(2025, 4, 18, 16, 15),
        imagePath: 'assets/images/disease_healthy.png',
        isHealthy: true,
        symptoms: ['Clean vibrant foliage without discoloration or lesions'],
        treatments: [
          'Continue scheduled drip irrigation',
          'Maintain balanced NPK fertilizer management',
        ],
        fieldNotes: 'Main Field',
        isSavedLocally: true,
      ),
      ScanReport(
        id: 'rep_003',
        title: 'Red Rot (लाल कुज)',
        diseaseName: 'Red Rot',
        scientificName: 'Colletotrichum falcatum',
        marathiName: 'उसावरील तांबडे कूज (लाल कुज)',
        confidenceScore: 0.91,
        severity: DiseaseSeverity.high,
        scanDate: DateTime(2025, 4, 16, 9, 30),
        imagePath: 'assets/images/disease_red_rot.png',
        isHealthy: false,
        symptoms: [
          'Reddish discoloration of vascular bundles',
          'Characteristic white horizontal transverse patches across midrib',
          'Withering and drooping of crown leaves',
        ],
        treatments: [
          'Remove severely affected plants',
          'Use recommended fungicides (as per expert advice)',
          'Ensure proper drainage',
        ],
        fieldNotes: 'North Field',
        isSavedLocally: true,
      ),
      ScanReport(
        id: 'rep_004',
        title: 'Rust (तांबेरा)',
        diseaseName: 'Rust',
        scientificName: 'Puccinia melanocephala',
        marathiName: 'उसावरील तांबेरा (Rust)',
        confidenceScore: 0.87,
        severity: DiseaseSeverity.moderate,
        scanDate: DateTime(2025, 4, 12, 11, 45),
        imagePath: 'assets/images/disease_rust.png',
        isHealthy: false,
        symptoms: [
          'Small, elongated yellowish spots on both surfaces of leaf',
          'Spots turn brownish-red and form pustules',
        ],
        treatments: [
          'Spray wettable sulphur or expert recommended fungicide',
          'Avoid excess nitrogen fertilizer application',
        ],
        fieldNotes: 'Plot #1',
        isSavedLocally: true,
      ),
      // 8 additional healthy scans to complete the 12 scans (9 healthy, 3 diseased)
      ScanReport(
        id: 'rep_005',
        title: 'Healthy Sugarcane Leaf',
        diseaseName: 'Healthy',
        scientificName: 'Saccharum officinarum',
        marathiName: 'निरोगी ऊस',
        confidenceScore: 0.97,
        severity: DiseaseSeverity.none,
        scanDate: DateTime(2025, 4, 10, 14, 20),
        imagePath: 'assets/images/disease_healthy.png',
        isHealthy: true,
        symptoms: ['Clean foliage without lesions'],
        treatments: ['Continue balanced irrigation'],
        fieldNotes: 'Plot #3 (South)',
        isSavedLocally: true,
      ),
      ScanReport(
        id: 'rep_006',
        title: 'Healthy Sugarcane Leaf',
        diseaseName: 'Healthy',
        scientificName: 'Saccharum officinarum',
        marathiName: 'निरोगी ऊस',
        confidenceScore: 0.95,
        severity: DiseaseSeverity.none,
        scanDate: DateTime(2025, 4, 8, 10, 15),
        imagePath: 'assets/images/disease_healthy.png',
        isHealthy: true,
        symptoms: ['Normal growth vigor'],
        treatments: ['Scheduled weeding'],
        fieldNotes: 'Plot #2 (East)',
        isSavedLocally: true,
      ),
      ScanReport(
        id: 'rep_007',
        title: 'Healthy Sugarcane Leaf',
        diseaseName: 'Healthy',
        scientificName: 'Saccharum officinarum',
        marathiName: 'निरोगी ऊस',
        confidenceScore: 0.96,
        severity: DiseaseSeverity.none,
        scanDate: DateTime(2025, 4, 5, 17, 00),
        imagePath: 'assets/images/disease_healthy.png',
        isHealthy: true,
        symptoms: ['Vibrant chlorophyll content'],
        treatments: ['Standard drip cycle'],
        fieldNotes: 'Plot #1 (Canal side)',
        isSavedLocally: true,
      ),
      ScanReport(
        id: 'rep_008',
        title: 'Healthy Sugarcane Leaf',
        diseaseName: 'Healthy',
        scientificName: 'Saccharum officinarum',
        marathiName: 'निरोगी ऊस',
        confidenceScore: 0.99,
        severity: DiseaseSeverity.none,
        scanDate: DateTime(2025, 4, 2, 8, 45),
        imagePath: 'assets/images/disease_healthy.png',
        isHealthy: true,
        symptoms: ['Healthy tillering'],
        treatments: ['Urea top dressing complete'],
        fieldNotes: 'Main Field Center',
        isSavedLocally: true,
      ),
      ScanReport(
        id: 'rep_009',
        title: 'Healthy Sugarcane Leaf',
        diseaseName: 'Healthy',
        scientificName: 'Saccharum officinarum',
        marathiName: 'निरोगी ऊस',
        confidenceScore: 0.94,
        severity: DiseaseSeverity.none,
        scanDate: DateTime(2025, 3, 29, 11, 30),
        imagePath: 'assets/images/disease_healthy.png',
        isHealthy: true,
        symptoms: ['Clean leaf canopy'],
        treatments: ['Soil moisture adequate'],
        fieldNotes: 'Plot #4',
        isSavedLocally: true,
      ),
      ScanReport(
        id: 'rep_010',
        title: 'Healthy Sugarcane Leaf',
        diseaseName: 'Healthy',
        scientificName: 'Saccharum officinarum',
        marathiName: 'निरोगी ऊस',
        confidenceScore: 0.98,
        severity: DiseaseSeverity.none,
        scanDate: DateTime(2025, 3, 27, 15, 10),
        imagePath: 'assets/images/disease_healthy.png',
        isHealthy: true,
        symptoms: ['Optimal internode length'],
        treatments: ['Routine inspection'],
        fieldNotes: 'Plot #2 North',
        isSavedLocally: true,
      ),
      ScanReport(
        id: 'rep_011',
        title: 'Healthy Sugarcane Leaf',
        diseaseName: 'Healthy',
        scientificName: 'Saccharum officinarum',
        marathiName: 'निरोगी ऊस',
        confidenceScore: 0.96,
        severity: DiseaseSeverity.none,
        scanDate: DateTime(2025, 3, 25, 9, 50),
        imagePath: 'assets/images/disease_healthy.png',
        isHealthy: true,
        symptoms: ['Healthy cane stems'],
        treatments: ['Micronutrient spray done'],
        fieldNotes: 'Main Field Border',
        isSavedLocally: true,
      ),
      ScanReport(
        id: 'rep_012',
        title: 'Healthy Sugarcane Leaf',
        diseaseName: 'Healthy',
        scientificName: 'Saccharum officinarum',
        marathiName: 'निरोगी ऊस',
        confidenceScore: 0.97,
        severity: DiseaseSeverity.none,
        scanDate: DateTime(2025, 3, 24, 16, 40),
        imagePath: 'assets/images/disease_healthy.png',
        isHealthy: true,
        symptoms: ['Uniform germination & tillering'],
        treatments: ['First fertilizer split applied'],
        fieldNotes: 'Plot #1 South',
        isSavedLocally: true,
      ),
    ];
  }
}
