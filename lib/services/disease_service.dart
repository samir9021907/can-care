import '../models/disease_info.dart';

abstract class DiseaseService {
  Future<List<DiseaseInfo>> getAllDiseases();
  Future<DiseaseInfo?> getDiseaseById(String id);
  Future<List<DiseaseInfo>> searchDiseases(String query, {String? category});
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
