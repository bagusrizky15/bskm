import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../models/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  final _supabase = Supabase.instance.client;
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        final userData = await _supabase
            .from('users')
            .select()
            .eq('id', user.id)
            .single();

        _currentUser = UserModel(
          id: user.id,
          name: userData['name'] ?? '',
          email: userData['email'] ?? '',
          phone: userData['phone'] ?? '',
          location: userData['location'] ?? '',
          isAdmin: userData['is_admin'] ?? false,
        );
        emit(AuthSuccess(_currentUser!));
      }
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Login gagal: ${e.toString()}'));
    }
  }

  Future<void> register(
    String fullName,
    String email,
    String phone,
    String password,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        await _supabase.from('users').insert({
          'id': user.id,
          'name': fullName,
          'email': email,
          'phone': phone,
          'location': 'Unknown',
          'is_admin': false,
        });

        _currentUser = UserModel(
          id: user.id,
          name: fullName,
          email: email,
          phone: phone,
          location: 'Unknown',
          isAdmin: false,
        );
        emit(AuthSuccess(_currentUser!));
      }
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Pendaftaran gagal: ${e.toString()}'));
    }
  }

  Future<void> loginAsAdmin(String email, String password) async {
    emit(const AuthLoading());

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        final userData = await _supabase
            .from('users')
            .select()
            .eq('id', user.id)
            .eq('is_admin', true)
            .single();

        _currentUser = UserModel(
          id: user.id,
          name: userData['name'] ?? '',
          email: userData['email'] ?? '',
          phone: userData['phone'] ?? '',
          location: userData['location'] ?? '',
          isAdmin: true,
        );
        emit(AuthSuccess(_currentUser!));
      }
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Login admin gagal: ${e.toString()}'));
    }
  }

  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
      _currentUser = null;
      emit(const AuthLoggedOut());
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthFailure('Logout gagal: ${e.toString()}'));
    }
  }
}
