import 'package:equatable/equatable.dart';
import '../../models/waste_model.dart';

abstract class PickupState extends Equatable {
  const PickupState();

  @override
  List<Object?> get props => [];
}

class PickupInitial extends PickupState {
  const PickupInitial();
}

class PickupFormChanged extends PickupState {
  final String selectedCategory;
  final double weight;
  final int estimatedPrice;
  final DateTime selectedDate;

  const PickupFormChanged({
    required this.selectedCategory,
    required this.weight,
    required this.estimatedPrice,
    required this.selectedDate,
  });

  @override
  List<Object?> get props =>
      [selectedCategory, weight, estimatedPrice, selectedDate];
}

class PickupSubmitting extends PickupState {
  const PickupSubmitting();
}

class PickupSuccess extends PickupState {
  const PickupSuccess();
}

class PickupFailure extends PickupState {
  final String message;

  const PickupFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class PickupLoading extends PickupState {
  const PickupLoading();
}

class PickupLoaded extends PickupState {
  final List<WastePickup> pickups;

  const PickupLoaded(this.pickups);

  @override
  List<Object?> get props => [pickups];
}
