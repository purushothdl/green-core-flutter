// lib/providers/dispose_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/dispose_model.dart';
import '../services/dispose_service.dart';

class DisposeProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> disposeWaste({
    required DisposeModel disposeData,
    required File photo,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await DisposeService.disposeWaste(
        orgName: disposeData.orgName,
        wasteType: disposeData.wasteType,
        weight: disposeData.weight,
        photo: photo,
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
