import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../models/disease_info.dart';
import '../models/scan_report.dart';
import 'api_client.dart';

abstract class ReportService {
  Future<List<ScanReport>> getReports();
  Future<ScanReport> saveReport(ScanReport report);
  Future<bool> deleteReport(String id);
}

class RemoteReportService implements ReportService {
  final ApiClient _apiClient = ApiClient();
  final LocalReportService _fallbackService = LocalReportService();

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
  Future<List<ScanReport>> getReports() async {
    try {
      final token = await _apiClient.getAuthToken();
      if (token == null || token.isEmpty) {
        return _fallbackService.getReports();
      }

      final res = await _apiClient.get(
        ApiConstants.history,
        queryParams: {'filter': 'all', 'page': '1', 'limit': '50'},
      );

      if (res is Map<String, dynamic> && res['scans'] is List) {
        final list = (res['scans'] as List).cast<Map<String, dynamic>>();
        final localDiseases = DiseaseInfo.getSugarcaneDiseases();

        final reports = list.map((item) {
          final scanId = item['scan_id']?.toString() ?? item['id']?.toString() ?? '';
          final diseaseName = item['disease_name']?.toString() ?? 'Sugarcane Scan';
          final confidence = (item['confidence'] as num?)?.toDouble() ?? 0.90;
          final rawSeverity = item['severity']?.toString() ?? 'none';
          final status = (item['status'] ?? '').toString().toLowerCase();
          final isHealthy = status == 'healthy' || diseaseName.toLowerCase().contains('healthy');
          final scanDateStr = item['created_at']?.toString() ?? '';
          final scanDate = DateTime.tryParse(scanDateStr) ?? DateTime.now();

          final matchedLocal = localDiseases.firstWhere(
            (d) => d.name.toLowerCase() == diseaseName.toLowerCase() || d.id.toLowerCase() == diseaseName.toLowerCase(),
            orElse: () => localDiseases.firstWhere((d) => d.isHealthy == isHealthy, orElse: () => localDiseases.first),
          );

          return ScanReport(
            id: scanId,
            title: diseaseName,
            diseaseName: diseaseName,
            scientificName: matchedLocal.scientificName,
            marathiName: matchedLocal.marathiName,
            hindiName: matchedLocal.hindiName,
            confidenceScore: confidence,
            severity: _parseSeverity(rawSeverity),
            scanDate: scanDate,
            imagePath: item['image_url']?.toString(),
            isHealthy: isHealthy,
            isLowConfidence: confidence < 0.6,
            symptoms: matchedLocal.symptoms,
            treatments: matchedLocal.treatment.culturalPractices,
            fieldNotes: item['notes']?.toString() ?? '',
            isSavedLocally: false,
          );
        }).toList();

        return reports;
      }
    } catch (e) {
      debugPrint('Remote getReports error: $e, using local storage');
    }
    return _fallbackService.getReports();
  }

  @override
  Future<ScanReport> saveReport(ScanReport report) async {
    // Keep local cache synced as well
    await _fallbackService.saveReport(report);
    return report;
  }

  @override
  Future<bool> deleteReport(String id) async {
    try {
      await _apiClient.delete(ApiConstants.deleteScan(id));
      await _fallbackService.deleteReport(id);
      return true;
    } catch (e) {
      debugPrint('Remote deleteReport error: $e');
      return _fallbackService.deleteReport(id);
    }
  }
}

class LocalReportService implements ReportService {
  static final List<ScanReport> _sharedReports = [];
  static bool _initialized = false;
  bool simulateSaveFailure = false;

  LocalReportService() {
    if (!_initialized) {
      _sharedReports.addAll(ScanReport.mockHistory());
      _initialized = true;
    }
  }

  @override
  Future<List<ScanReport>> getReports() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_sharedReports);
  }

  @override
  Future<ScanReport> saveReport(ScanReport report) async {
    await Future.delayed(const Duration(milliseconds: 350));
    if (simulateSaveFailure) {
      throw Exception('Failed to save report to local demo storage.');
    }
    // Remove if duplicate exists, then insert at the top
    _sharedReports.removeWhere((r) => r.id == report.id);
    _sharedReports.insert(0, report);
    return report;
  }

  @override
  Future<bool> deleteReport(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final initialLen = _sharedReports.length;
    _sharedReports.removeWhere((r) => r.id == id);
    return _sharedReports.length < initialLen;
  }
}
