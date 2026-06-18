import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _currentUser = User(
      id: '1',
      name: 'Budi Santoso',
      email: email,
      phone: '082123456789',
      location: 'Jl. Mawar No. 12, Bandung',
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(
    String fullName,
    String email,
    String phone,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _currentUser = User(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      name: fullName,
      email: email,
      phone: phone,
      location: 'Unknown',
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginAsAdmin(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _currentUser = User(
      id: 'admin-1',
      name: 'Admin Pusat',
      email: email,
      phone: '082123456789',
      location: 'Admin Center',
      isAdmin: true,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
}
