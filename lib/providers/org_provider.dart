// lib/providers/org_provider.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/org_model.dart';
import '../services/org_service.dart';

class OrgProvider with ChangeNotifier {
  List<Org> _orgs = [];
  Position? _userPosition;
  bool _isLoading = false;

  List<Org> get orgs => _orgs;
  Position? get userPosition => _userPosition;
  bool get isLoading => _isLoading;

  // Fetch orgs and user location
  Future<void> fetchOrgsAndLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch user location
      _userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Fetch orgs
      _orgs = await OrgService.fetchOrgs();
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh orgs and location
  Future<void> refresh() async {
    await fetchOrgsAndLocation();
  }
}