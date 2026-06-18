import 'package:equatable/equatable.dart';
import '../../models/waste_model.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {
  const AdminInitial();
}

class AdminLoaded extends AdminState {
  final List<WastePickup> pickups;
  final PickupStatus? selectedFilter;
  final int totalUsers;
  final int totalWaste;

  const AdminLoaded({
    required this.pickups,
    this.selectedFilter,
    required this.totalUsers,
    required this.totalWaste,
  });

  @override
  List<Object?> get props =>
      [pickups, selectedFilter, totalUsers, totalWaste];
}

class AdminLoading extends AdminState {
  const AdminLoading();
}

class AdminFailure extends AdminState {
  final String message;

  const AdminFailure(this.message);

  @override
  List<Object?> get props => [message];
}
