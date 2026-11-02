import '../localization/app_localizations.dart';

/// Clean typed model for sugarcane treatment and management guidance
class TreatmentGuidance {
  final List<String> culturalPractices;
  final List<String> culturalPracticesMarathi;
  final List<String> culturalPracticesHindi;

  final List<String> organicMeasures;
  final List<String> organicMeasuresMarathi;
  final List<String> organicMeasuresHindi;

  final List<String> generalPreventiveSteps;
  final List<String> generalPreventiveStepsMarathi;
  final List<String> generalPreventiveStepsHindi;

  final String expertAdvisoryNote;
  final String expertAdvisoryNoteMarathi;
  final String expertAdvisoryNoteHindi;

  const TreatmentGuidance({
    required this.culturalPractices,
    this.culturalPracticesMarathi = const [],
    this.culturalPracticesHindi = const [],
    required this.organicMeasures,
    this.organicMeasuresMarathi = const [],
    this.organicMeasuresHindi = const [],
    required this.generalPreventiveSteps,
    this.generalPreventiveStepsMarathi = const [],
    this.generalPreventiveStepsHindi = const [],
    this.expertAdvisoryNote =
        'Always consult your local Krishi Vigyan Kendra (KVK) or State Agricultural University expert before applying chemical treatments.',
    this.expertAdvisoryNoteMarathi =
        'रासायनिक कीटकनाशके किंवा बुरशीनाशके वापरण्यापूर्वी नेहमी स्थानिक कृषी विज्ञान केंद्र (KVK) किंवा कृषी विद्यापीठाच्या तज्ञांचा सल्ला घ्या.',
    this.expertAdvisoryNoteHindi =
        'रासायनिक उपचार करने से पहले हमेशा अपने स्थानीय कृषि विज्ञान केंद्र (KVK) या राज्य कृषि विश्वविद्यालय के विशेषज्ञ से परामर्श लें।',
  });

  List<String> getCulturalPractices(AppLanguage lang) {
    if (lang == AppLanguage.marathi && culturalPracticesMarathi.isNotEmpty) {
      return culturalPracticesMarathi;
    }
    if (lang == AppLanguage.hindi && culturalPracticesHindi.isNotEmpty) {
      return culturalPracticesHindi;
    }
    return culturalPractices;
  }

  List<String> getOrganicMeasures(AppLanguage lang) {
    if (lang == AppLanguage.marathi && organicMeasuresMarathi.isNotEmpty) {
      return organicMeasuresMarathi;
    }
    if (lang == AppLanguage.hindi && organicMeasuresHindi.isNotEmpty) {
      return organicMeasuresHindi;
    }
    return organicMeasures;
  }

  List<String> getPreventiveSteps(AppLanguage lang) {
    if (lang == AppLanguage.marathi && generalPreventiveStepsMarathi.isNotEmpty) {
      return generalPreventiveStepsMarathi;
    }
    if (lang == AppLanguage.hindi && generalPreventiveStepsHindi.isNotEmpty) {
      return generalPreventiveStepsHindi;
    }
    return generalPreventiveSteps;
  }

  String getExpertNote(AppLanguage lang) {
    if (lang == AppLanguage.marathi && expertAdvisoryNoteMarathi.isNotEmpty) {
      return expertAdvisoryNoteMarathi;
    }
    if (lang == AppLanguage.hindi && expertAdvisoryNoteHindi.isNotEmpty) {
      return expertAdvisoryNoteHindi;
    }
    return expertAdvisoryNote;
  }

  Map<String, dynamic> toJson() => {
        'culturalPractices': culturalPractices,
        'organicMeasures': organicMeasures,
        'generalPreventiveSteps': generalPreventiveSteps,
        'expertAdvisoryNote': expertAdvisoryNote,
      };

  factory TreatmentGuidance.fromJson(Map<String, dynamic> json) =>
      TreatmentGuidance(
        culturalPractices: List<String>.from(json['culturalPractices'] ?? []),
        organicMeasures: List<String>.from(json['organicMeasures'] ?? []),
        generalPreventiveSteps:
            List<String>.from(json['generalPreventiveSteps'] ?? []),
        expertAdvisoryNote: json['expertAdvisoryNote'] ?? '',
      );
}
