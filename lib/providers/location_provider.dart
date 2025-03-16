// lib/providers/location_provider.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  String? _errorMessage;

  Position? get currentPosition => _currentPosition;
  String? get errorMessage => _errorMessage;

  Future<void> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _errorMessage = "Location services are disabled. Please enable them.";
      notifyListeners();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _errorMessage = "Location permissions are denied.";
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _errorMessage = "Location permissions are permanently denied. Please enable them in app settings.";
      notifyListeners();
      return;
    }

    // If permissions are granted, get the current location
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to get location: ${e.toString()}";
      notifyListeners();
    }
  }
}