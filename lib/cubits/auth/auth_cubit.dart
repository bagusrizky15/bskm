import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(seconds: 1));

    try {
      _currentUser = UserModel(
        id: '1',
        name: 'Budi Santoso',
        email: email,
        phone: '082123456789',
        location: 'Jl. Mawar No. 12, Bandung',
      );
      emit(AuthSuccess(_currentUser!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> register(
    String fullName,
    String email,
    String phone,
    String password,
  ) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(seconds: 1));

    try {
      _currentUser = UserModel(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        name: fullName,
        email: email,
        phone: phone,
        location: 'Unknown',
      );
      emit(AuthSuccess(_currentUser!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> loginAsAdmin(String email, String password) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(seconds: 1));

    try {
      _currentUser = UserModel(
        id: 'admin-1',
        name: 'Admin Pusat',
        email: email,
        phone: '082123456789',
        location: 'Admin Center',
        isAdmin: true,
      );
      emit(AuthSuccess(_currentUser!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    emit(const AuthLoggedOut());
    emit(const AuthInitial());
  }
}
