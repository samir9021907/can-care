import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../models/disease_info.dart';
import '../models/treatment_guidance.dart';
import 'api_client.dart';

abstract class DiseaseService {
  Future<List<DiseaseInfo>> getAllDiseases();
  Future<DiseaseInfo?> getDiseaseById(String id);
  Future<List<DiseaseInfo>> searchDiseases(String query, {String? category});
}

class RemoteDiseaseService implements DiseaseService {
  final ApiClient _apiClient = ApiClient();
  final LocalDiseaseService _fallbackService = LocalDiseaseService();
  List<DiseaseInfo>? _cache;

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
  Future<List<DiseaseInfo>> getAllDiseases() async {
    if (_cache != null && _cache!.isNotEmpty) {
      return _cache!;
    }
    try {
      final res = await _apiClient.get(ApiConstants.diseases, queryParams: {'lang': 'en'});
      final localDiseases = DiseaseInfo.getSugarcaneDiseases();
      if (res is Map<String, dynamic> && res['diseases'] is List) {
        final list = (res['diseases'] as List).cast<Map<String, dynamic>>();
        _cache = list.map((item) {
          final code = item['disease_code']?.toString() ?? '';
          final matchedLocal = localDiseases.firstWhere(
            (d) => d.id.toLowerCase() == code.toLowerCase() || d.name.toLowerCase() == (item['name'] ?? '').toString().toLowerCase(),
            orElse: () => localDiseases.first,
          );

          final symptoms = (item['symptoms'] as List?)?.map((e) => e.toString()).toList() ?? matchedLocal.symptoms;
          final causes = (item['causes'] as List?)?.map((e) => e.toString()).toList() ?? matchedLocal.causes;
          final treatment = (item['treatment'] as List?)?.map((e) => e.toString()).toList() ?? matchedLocal.treatment.culturalPractices;
          final prevention = (item['prevention'] as List?)?.map((e) => e.toString()).toList() ?? matchedLocal.treatment.generalPreventiveSteps;

          return DiseaseInfo(
            id: code.isNotEmpty ? code : matchedLocal.id,
            name: item['name']?.toString() ?? matchedLocal.name,
            scientificName: matchedLocal.scientificName,
            marathiName: matchedLocal.marathiName,
            hindiName: matchedLocal.hindiName,
            pathogenType: matchedLocal.pathogenType,
            typicalSeverity: _parseSeverity(item['severity'] ?? matchedLocal.typicalSeverity.name),
            overview: item['overview']?.toString() ?? matchedLocal.overview,
            overviewMarathi: matchedLocal.overviewMarathi,
            overviewHindi: matchedLocal.overviewHindi,
            symptoms: symptoms,
            symptomsMarathi: matchedLocal.symptomsMarathi,
            symptomsHindi: matchedLocal.symptomsHindi,
            causes: causes,
            causesMarathi: matchedLocal.causesMarathi,
            causesHindi: matchedLocal.causesHindi,
            treatment: TreatmentGuidance(
              culturalPractices: treatment,
              culturalPracticesMarathi: matchedLocal.treatment.culturalPracticesMarathi,
              culturalPracticesHindi: matchedLocal.treatment.culturalPracticesHindi,
              organicMeasures: matchedLocal.treatment.organicMeasures,
              organicMeasuresMarathi: matchedLocal.treatment.organicMeasuresMarathi,
              organicMeasuresHindi: matchedLocal.treatment.organicMeasuresHindi,
              generalPreventiveSteps: prevention,
              generalPreventiveStepsMarathi: matchedLocal.treatment.generalPreventiveStepsMarathi,
              generalPreventiveStepsHindi: matchedLocal.treatment.generalPreventiveStepsHindi,
              expertAdvisoryNote: matchedLocal.treatment.expertAdvisoryNote,
              expertAdvisoryNoteMarathi: matchedLocal.treatment.expertAdvisoryNoteMarathi,
              expertAdvisoryNoteHindi: matchedLocal.treatment.expertAdvisoryNoteHindi,
            ),
            imageAsset: matchedLocal.imageAsset,
            isHealthy: code.toLowerCase().contains('healthy') || (item['name'] ?? '').toString().toLowerCase().contains('healthy'),
          );
        }).toList();
        return _cache!;
      }
    } catch (e) {
      debugPrint('Remote diseases fetch failed: $e, using local fallback');
    }
    return _fallbackService.getAllDiseases();
  }

  @override
  Future<DiseaseInfo?> getDiseaseById(String id) async {
    final list = await getAllDiseases();
    try {
      return list.firstWhere((d) => d.id.toLowerCase() == id.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<DiseaseInfo>> searchDiseases(String query, {String? category}) async {
    final list = await getAllDiseases();
    final lower = query.toLowerCase().trim();
    return list.where((d) {
      final matchesQuery = lower.isEmpty ||
          d.name.toLowerCase().contains(lower) ||
          d.marathiName.toLowerCase().contains(lower) ||
          d.hindiName.toLowerCase().contains(lower) ||
          d.scientificName.toLowerCase().contains(lower) ||
          d.overview.toLowerCase().contains(lower);

      final matchesCategory = category == null ||
          category == 'All' ||
          (category == 'Healthy' && d.isHealthy) ||
          (category == 'Fungal' && d.pathogenType == 'Fungal') ||
          (category == 'Viral' && d.pathogenType == 'Viral');

      return matchesQuery && matchesCategory;
    }).toList();
  }
}

class LocalDiseaseService implements DiseaseService {
  final List<DiseaseInfo> _diseases = DiseaseInfo.getSugarcaneDiseases();

  @override
  Future<List<DiseaseInfo>> getAllDiseases() async {
    return _diseases;
  }

  @override
  Future<DiseaseInfo?> getDiseaseById(String id) async {
    try {
      return _diseases.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<DiseaseInfo>> searchDiseases(String query,
      {String? category}) async {
    final lower = query.toLowerCase().trim();
    return _diseases.where((d) {
      final matchesQuery = lower.isEmpty ||
          d.name.toLowerCase().contains(lower) ||
          d.marathiName.toLowerCase().contains(lower) ||
          d.hindiName.toLowerCase().contains(lower) ||
          d.scientificName.toLowerCase().contains(lower) ||
          d.overview.toLowerCase().contains(lower);

      final matchesCategory = category == null ||
          category == 'All' ||
          (category == 'Healthy' && d.isHealthy) ||
          (category == 'Fungal' && d.pathogenType == 'Fungal') ||
          (category == 'Viral' && d.pathogenType == 'Viral');

      return matchesQuery && matchesCategory;
    }).toList();
  }
}
