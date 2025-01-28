// lib/providers/org_provider.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/org_model.dart';
import '../services/org_service.dart';

class OrgProvider with ChangeNotifier {
  List<Org> _orgs = [];
  Position? _userPosition;
  bool _isLoading = false;
  bool _isLoaded = false;
  String? _selectedOrgId; // Store the selected org ID for highlighting

  List<Org> get orgs => _orgs;
  Position? get userPosition => _userPosition;
  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  String? get selectedOrgId => _selectedOrgId; // Getter for selected org ID

  // Fetch orgs and user location
  Future<void> fetchOrgsAndLocation({bool forceRefresh = false}) async {
    if (_isLoaded && !forceRefresh) return;

    _isLoading = true;
    notifyListeners();

    try {
      _userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _orgs = await OrgService.fetchOrgs();
      _isLoaded = true;
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Select org and highlight it
  void selectOrg(String orgId) {
    _selectedOrgId = orgId;
    notifyListeners();

    // Reset the highlight after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      _selectedOrgId = null;
      notifyListeners();
    });
  }

  // Refresh orgs and location
  Future<void> refresh() async {
    await fetchOrgsAndLocation(forceRefresh: true);
  }

  // Calculate the distance between the user's location and the org
  Future<double> getDistanceToOrg(String orgId) async {
    if (_userPosition == null) {
      return 0.0; // No user location
    }

    final org = _orgs.firstWhere((org) => org.id == orgId);
    final orgLatitude = org.latitude;
    final orgLongitude = org.longitude;

    // Calculate the distance using Geolocator
    double distanceInMeters = Geolocator.distanceBetween(
      _userPosition!.latitude,
      _userPosition!.longitude,
      orgLatitude,
      orgLongitude,
    );

    return distanceInMeters;
  }
}
