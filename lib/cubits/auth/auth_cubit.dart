import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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

  Future<void> checkSession() async {
    final session = _supabase.auth.currentSession;
    if (session == null) {
      emit(const AuthInitial());
      return;
    }

    try {
      final user = _supabase.auth.currentUser!;
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
    } catch (_) {
      emit(const AuthInitial());
    }
  }

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
      } else {
        emit(const AuthFailure(
            'Tidak ada respons dari server', AuthOperation.login));
      }
    } on AuthException catch (e) {
      emit(AuthFailure(e.message, AuthOperation.login));
    } catch (e) {
      emit(AuthFailure(e.toString(), AuthOperation.login));
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
        data: {
          'name': fullName,
          'phone': phone,
        },
      );

      final user = response.user;
      if (user != null) {
        // ponytail: upsert profile from client when we have a session;
        // surfaces real Postgres errors instead of GoTrue's generic
        // "Database error saving user". Needs INSERT RLS policy (see migration).
        // If email confirmation is on (no session), the DB trigger handles it.
        if (response.session != null) {
          await _supabase.from('users').upsert({
            'id': user.id,
            'name': fullName,
            'email': email,
            'phone': phone,
          });
        }
        emit(AuthRegisterSuccess(email));
      } else {
        emit(const AuthFailure(
            'Tidak ada respons dari server', AuthOperation.register));
      }
    } on AuthException catch (e) {
      emit(AuthFailure(e.message, AuthOperation.register));
    } catch (e) {
      emit(AuthFailure(e.toString(), AuthOperation.register));
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
      } else {
        emit(const AuthFailure(
            'Tidak ada respons dari server', AuthOperation.loginAdmin));
      }
    } on AuthException catch (e) {
      emit(AuthFailure(e.message, AuthOperation.loginAdmin));
    } catch (e) {
      emit(AuthFailure(e.toString(), AuthOperation.loginAdmin));
    }
  }

  Future<void> updateLocation() async {
    if (_currentUser == null) return;

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String locationStr = '';
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [
          if (p.street != null && p.street!.isNotEmpty) p.street,
          if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality,
          if (p.locality != null && p.locality!.isNotEmpty) p.locality,
        ];
        locationStr = parts.join(', ');
      }

      await _supabase
          .from('users')
          .update({'location': locationStr})
          .eq('id', _currentUser!.id);

      _currentUser = UserModel(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        location: locationStr,
        isAdmin: _currentUser!.isAdmin,
      );
      emit(AuthSuccess(_currentUser!));
    } catch (_) {}
  }

  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
      _currentUser = null;
      emit(const AuthLoggedOut());
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString(), AuthOperation.logout));
    }
  }
}
