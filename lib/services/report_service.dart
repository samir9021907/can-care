import '../models/scan_report.dart';

abstract class ReportService {
  Future<List<ScanReport>> getReports();
  Future<ScanReport> saveReport(ScanReport report);
  Future<bool> deleteReport(String id);
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
