// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _user;
   bool _isUserLoaded = false;

  User? get user => _user;
  bool get isUserLoaded => _isUserLoaded;

  Future<void> fetchUserDetails({bool forceRefresh = false}) async {
    if (_isUserLoaded && !forceRefresh) return;
    _isLoading = true;
    _isUserLoaded = true;
    notifyListeners();

    try {
      _user = await AuthService.fetchUserDetails();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUserDetails() async {
    _isUserLoaded = false;
    await fetchUserDetails();
  }

  Future<void> registerUser(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.registerUser(user);
    } catch (e) {
      rethrow; // Preserve original error stack
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginUser(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.loginUser(email, password);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}