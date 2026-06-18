import 'package:flutter/material.dart';
import '../models/waste_model.dart';

class AdminViewModel extends ChangeNotifier {
  List<WastePickup> _pickups = [];
  List<WastePickup> _filteredPickups = [];
  PickupStatus? _selectedFilter;
  bool _isLoading = false;

  List<WastePickup> get pickups => _filteredPickups;
  PickupStatus? get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;

  int get totalUsers => 138;
  int get totalWaste => 52;

  AdminViewModel() {
    _initializePickups();
  }

  void _initializePickups() {
    _pickups = [
      WastePickup(
        id: 'PJP-2026-001',
        userId: 'user1',
        userName: 'Budi Santoso',
        category: WasteCategory.plastic,
        weight: 2.3,
        estimatedPrice: 5750,
        pickupDate: DateTime(2026, 6, 18),
        address: 'Jl. Mawar No. 12, Bandung',
        status: PickupStatus.waiting,
      ),
      WastePickup(
        id: 'PJP-2026-002',
        userId: 'user2',
        userName: 'Siti Rahayu',
        category: WasteCategory.paper,
        weight: 4.0,
        estimatedPrice: 6000,
        pickupDate: DateTime(2026, 6, 18),
        address: 'Jl. Sudirman No. 45, Bandung',
        status: PickupStatus.waiting,
      ),
      WastePickup(
        id: 'PJP-2026-003',
        userId: 'user3',
        userName: 'Ahmad Fauzi',
        category: WasteCategory.metal,
        weight: 1.5,
        estimatedPrice: 7500,
        pickupDate: DateTime(2026, 6, 19),
        address: 'Jl. Gatot Subroto No. 78, Bandung',
        status: PickupStatus.confirmed,
      ),
      WastePickup(
        id: 'PJP-2026-004',
        userId: 'user4',
        userName: 'Dewi Lestari',
        category: WasteCategory.glass,
        weight: 3.2,
        estimatedPrice: 3200,
        pickupDate: DateTime(2026, 6, 19),
        address: 'Jl. Ahmad Yani No. 23, Bandung',
        status: PickupStatus.waiting,
      ),
      WastePickup(
        id: 'PJP-2026-005',
        userId: 'user5',
        userName: 'Rudi Hermawan',
        category: WasteCategory.plastic,
        weight: 5.0,
        estimatedPrice: 12500,
        pickupDate: DateTime(2026, 6, 20),
        address: 'Jl. Cihampelas No. 56, Bandung',
        status: PickupStatus.rejected,
      ),
    ];
    _filteredPickups = _pickups;
  }

  void setFilter(PickupStatus? status) {
    _selectedFilter = status;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_selectedFilter == null) {
      _filteredPickups = _pickups;
    } else {
      _filteredPickups = _pickups
          .where((pickup) => pickup.status == _selectedFilter)
          .toList();
    }
  }

  Future<void> confirmPickup(String pickupId) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final index = _pickups.indexWhere((p) => p.id == pickupId);
    if (index != -1) {
      _pickups[index] = WastePickup(
        id: _pickups[index].id,
        userId: _pickups[index].userId,
        userName: _pickups[index].userName,
        category: _pickups[index].category,
        weight: _pickups[index].weight,
        estimatedPrice: _pickups[index].estimatedPrice,
        pickupDate: _pickups[index].pickupDate,
        address: _pickups[index].address,
        notes: _pickups[index].notes,
        status: PickupStatus.confirmed,
      );
      _applyFilter();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> rejectPickup(String pickupId) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final index = _pickups.indexWhere((p) => p.id == pickupId);
    if (index != -1) {
      _pickups[index] = WastePickup(
        id: _pickups[index].id,
        userId: _pickups[index].userId,
        userName: _pickups[index].userName,
        category: _pickups[index].category,
        weight: _pickups[index].weight,
        estimatedPrice: _pickups[index].estimatedPrice,
        pickupDate: _pickups[index].pickupDate,
        address: _pickups[index].address,
        notes: _pickups[index].notes,
        status: PickupStatus.rejected,
      );
      _applyFilter();
    }

    _isLoading = false;
    notifyListeners();
  }
}
