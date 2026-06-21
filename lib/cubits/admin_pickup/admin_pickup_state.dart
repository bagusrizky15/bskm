import 'package:equatable/equatable.dart';
import '../../models/waste_model.dart';

abstract class AdminPickupState extends Equatable {
  const AdminPickupState();

  @override
  List<Object?> get props => [];
}

class AdminPickupInitial extends AdminPickupState {
  const AdminPickupInitial();
}

class AdminPickupLoading extends AdminPickupState {
  const AdminPickupLoading();
}

class AdminPickupLoaded extends AdminPickupState {
  final List<WastePickup> pickups;
  final PickupStatus? selectedFilter;

  const AdminPickupLoaded({required this.pickups, this.selectedFilter});

  @override
  List<Object?> get props => [pickups, selectedFilter];
}

class AdminPickupFailure extends AdminPickupState {
  final String message;

  const AdminPickupFailure(this.message);

  @override
  List<Object?> get props => [message];
}
