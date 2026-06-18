import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/waste_model.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(const AdminInitial()) {
    loadPickups();
  }

  late List<WastePickup> _allPickups;
  PickupStatus? _selectedFilter;

  int get totalUsers => 138;
  int get totalWaste => 52;

  void loadPickups() {
    emit(const AdminLoading());

    try {
      _allPickups = [
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
      _emitLoaded();
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  void setFilter(PickupStatus? status) {
    _selectedFilter = status;
    _emitLoaded();
  }

  Future<void> confirmPickup(String pickupId) async {
    emit(const AdminLoading());
    await Future.delayed(const Duration(seconds: 1));

    try {
      final index = _allPickups.indexWhere((p) => p.id == pickupId);
      if (index != -1) {
        _allPickups[index] = WastePickup(
          id: _allPickups[index].id,
          userId: _allPickups[index].userId,
          userName: _allPickups[index].userName,
          category: _allPickups[index].category,
          weight: _allPickups[index].weight,
          estimatedPrice: _allPickups[index].estimatedPrice,
          pickupDate: _allPickups[index].pickupDate,
          address: _allPickups[index].address,
          notes: _allPickups[index].notes,
          status: PickupStatus.confirmed,
        );
      }
      _emitLoaded();
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  Future<void> rejectPickup(String pickupId) async {
    emit(const AdminLoading());
    await Future.delayed(const Duration(seconds: 1));

    try {
      final index = _allPickups.indexWhere((p) => p.id == pickupId);
      if (index != -1) {
        _allPickups[index] = WastePickup(
          id: _allPickups[index].id,
          userId: _allPickups[index].userId,
          userName: _allPickups[index].userName,
          category: _allPickups[index].category,
          weight: _allPickups[index].weight,
          estimatedPrice: _allPickups[index].estimatedPrice,
          pickupDate: _allPickups[index].pickupDate,
          address: _allPickups[index].address,
          notes: _allPickups[index].notes,
          status: PickupStatus.rejected,
        );
      }
      _emitLoaded();
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }

  void _emitLoaded() {
    final filtered = _selectedFilter == null
        ? _allPickups
        : _allPickups.where((p) => p.status == _selectedFilter).toList();

    emit(AdminLoaded(
      pickups: filtered,
      selectedFilter: _selectedFilter,
      totalUsers: totalUsers,
      totalWaste: totalWaste,
    ));
  }
}
