// lib/providers/profile_provider.dart


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:green_core/models/user_model.dart';
import 'package:green_core/services/profile_service.dart';
import 'package:green_core/services/auth_service.dart'; // Import AuthService

class ProfileProvider with ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  User? _user;
  bool _isLoading = false;
  bool _isUserLoaded = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isUserLoaded => _isUserLoaded;

  void setUser(User user) {
    _user = user;
    _isUserLoaded = true;
    notifyListeners();
  }

  Future<void> updateUserDetails(Map<String, dynamic> userData) async {
    try {
      final updatedUser = await _profileService.updateUserDetails(userData);
      if (updatedUser != null) {
        setUser(updatedUser);
      }
    } catch (e) {
      print('Error updating user details: $e');
    }
  }

  Future<void> uploadProfileImage(File image) async {
    try {
      final updatedUser = await _profileService.uploadProfileImage(image);
      if (updatedUser != null) {
        setUser(updatedUser);
      }
    } catch (e) {
      print('Error uploading profile image: $e');
    }
  }

  void clearUser() {
    _user = null;
    _isUserLoaded = false;
    notifyListeners();
  }

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
}