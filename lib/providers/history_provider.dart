import 'package:flutter/material.dart';
import '../models/scan_report.dart';
import '../services/report_service.dart';

enum HistoryFilter {
  all,
  healthy,
  diseased,
}

class HistoryProvider extends ChangeNotifier {
  final ReportService _reportService;

  List<ScanReport> _reports = [];
  bool _isLoading = false;
  String? _errorMessage;
  HistoryFilter _currentFilter = HistoryFilter.all;
  String _searchQuery = '';
  String? _lastDeletedId;

  HistoryProvider({ReportService? reportService})
      : _reportService = reportService ?? LocalReportService() {
    loadReports();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  HistoryFilter get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;
  String? get lastDeletedId => _lastDeletedId;
  List<ScanReport> get reports => List.unmodifiable(_reports);

  List<ScanReport> get filteredReports {
    return _reports.where((r) {
      // Filter check
      if (_currentFilter == HistoryFilter.healthy && !r.isHealthy) return false;
      if (_currentFilter == HistoryFilter.diseased && r.isHealthy) return false;

      // Search check
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = r.title.toLowerCase().contains(q) ||
            r.diseaseName.toLowerCase().contains(q) ||
            r.marathiName.toLowerCase().contains(q) ||
            r.fieldNotes.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  bool get isEmpty => _reports.isEmpty;
  bool get isFilteredEmpty => filteredReports.isEmpty && !isLoading;

  Future<void> loadReports({bool simulateError = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (simulateError) {
        throw Exception('Unable to load scan reports from local demo cache.');
      }
      final items = await _reportService.getReports();
      _reports = List.from(items);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void setFilter(HistoryFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<bool> deleteReport(String id) async {
    final success = await _reportService.deleteReport(id);
    if (success) {
      _lastDeletedId = id;
      _reports.removeWhere((r) => r.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }

  void clearReports() {
    _reports.clear();
    notifyListeners();
  }

  void insertReport(ScanReport report) {
    _reports.removeWhere((r) => r.id == report.id);
    _reports.insert(0, report);
    notifyListeners();
  }

  void restoreDemoReports() {
    _reports = List.from(ScanReport.mockHistory());
    _errorMessage = null;
    notifyListeners();
  }
}
