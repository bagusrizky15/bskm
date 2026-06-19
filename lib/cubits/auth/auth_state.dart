import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final UserModel user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

enum AuthOperation { login, register, loginAdmin, logout }

class AuthFailure extends AuthState {
  final String message;
  final AuthOperation operation;

  const AuthFailure(this.message, this.operation);

  @override
  List<Object?> get props => [message, operation];
}

class AuthRegisterSuccess extends AuthState {
  final String email;

  const AuthRegisterSuccess(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}
