import 'package:flutter/material.dart';
import '../models/waste_model.dart';

class PickupViewModel extends ChangeNotifier {
  String _selectedCategory = 'Plastik';
  double _weight = 2.5;
  DateTime _selectedDate = DateTime(2026, 6, 20);
  bool _isLoading = false;

  String get selectedCategory => _selectedCategory;
  double get weight => _weight;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;

  int get estimatedPrice {
    final category = WasteCategory.values
        .firstWhere((c) => c.name == _selectedCategory);
    return (category.pricePerKg * _weight).toInt();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setWeight(double weight) {
    _weight = weight;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> submitPickup(
    String name,
    String address,
    String? notes,
  ) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }
}
