import 'package:flutter/material.dart';
import '../models/disease_info.dart';
import '../services/disease_service.dart';

class DiseaseLibraryProvider extends ChangeNotifier {
  final DiseaseService _diseaseService;

  List<DiseaseInfo> _allDiseases = [];
  List<DiseaseInfo> _filteredDiseases = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  DiseaseInfo? _selectedDisease;

  DiseaseLibraryProvider({DiseaseService? diseaseService})
      : _diseaseService = diseaseService ?? LocalDiseaseService() {
    loadDiseases();
  }

  List<DiseaseInfo> get diseases => _filteredDiseases;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  DiseaseInfo? get selectedDisease => _selectedDisease;

  bool get isSearchEmpty =>
      _filteredDiseases.isEmpty && _searchQuery.isNotEmpty && !_isLoading;

  Future<void> loadDiseases() async {
    _isLoading = true;
    notifyListeners();

    _allDiseases = await _diseaseService.getAllDiseases();
    _applyFilter();
    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilter();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void selectDisease(DiseaseInfo disease) {
    _selectedDisease = disease;
    notifyListeners();
  }

  void _applyFilter() {
    final q = _searchQuery.toLowerCase().trim();
    _filteredDiseases = _allDiseases.where((d) {
      final matchesQuery = q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.marathiName.toLowerCase().contains(q) ||
          d.hindiName.toLowerCase().contains(q) ||
          d.scientificName.toLowerCase().contains(q) ||
          d.overview.toLowerCase().contains(q);

      final matchesCat = _selectedCategory == 'All' ||
          (_selectedCategory == 'Healthy' && d.isHealthy) ||
          (_selectedCategory == 'Diseased' && !d.isHealthy) ||
          (_selectedCategory == 'Fungal' && d.pathogenType == 'Fungal') ||
          (_selectedCategory == 'Viral' && d.pathogenType == 'Viral');

      return matchesQuery && matchesCat;
    }).toList();
  }
}
