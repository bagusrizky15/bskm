import 'package:equatable/equatable.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {
  const AdminInitial();
}

class AdminLoading extends AdminState {
  const AdminLoading();
}

class AdminLoaded extends AdminState {
  final int totalUsers;
  final int totalWaste;

  const AdminLoaded({required this.totalUsers, required this.totalWaste});

  @override
  List<Object?> get props => [totalUsers, totalWaste];
}

class AdminFailure extends AdminState {
  final String message;

  const AdminFailure(this.message);

  @override
  List<Object?> get props => [message];
}
