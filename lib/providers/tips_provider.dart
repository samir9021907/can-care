import 'package:flutter/material.dart';
import '../models/crop_tip.dart';

class TipsProvider extends ChangeNotifier {
  final List<CropTip> _tips = CropTip.getTips();
  CropTip? _selectedTip;

  List<CropTip> get tips => List.unmodifiable(_tips);
  CropTip? get selectedTip => _selectedTip ?? _tips.first;

  void selectTip(CropTip tip) {
    _selectedTip = tip;
    notifyListeners();
  }
}
