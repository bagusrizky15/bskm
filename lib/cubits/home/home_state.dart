import 'package:equatable/equatable.dart';
import '../../models/balance_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final Balance balance;

  const HomeLoaded(this.balance);

  @override
  List<Object?> get props => [balance];
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure(this.message);

  @override
  List<Object?> get props => [message];
}
