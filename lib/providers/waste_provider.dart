// lib/providers/waste_provider.dart
import 'package:flutter/material.dart';
import '../services/waste_service.dart';

class WasteProvider with ChangeNotifier {
  double _totalWeight = 0.0;
  Map<String, double> _wasteByType = {};
  List<Map<String, dynamic>> _graphData = [];
  bool _isLoading = false;
  bool _isLoaded = false;
  bool _isGraphLoading = false;

  double get totalWeight => _totalWeight;
  Map<String, double> get wasteByType => _wasteByType;
  List<Map<String, dynamic>> get graphData => _graphData;
  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  bool get isGraphLoading => _isGraphLoading;

  // Fetch waste stats
  Future<void> fetchWasteStats({bool forceRefresh = false}) async {
    if (_isLoaded && !forceRefresh) return; // Skip if already loaded and not forcing refresh

    _isLoading = true;
    notifyListeners();

    try {
      final data = await WasteService.fetchWasteStats();
      _totalWeight = (data['total_weight'] as num).toDouble();
      _wasteByType = (data['waste_by_type'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      );
      _isLoaded = true; // Mark as loaded
    } catch (e) {
      throw Exception('Failed to fetch waste stats: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch waste graph data
  Future<void> fetchWasteGraph({bool forceRefresh = false}) async {
    if (_graphData.isNotEmpty && !forceRefresh) return; // Skip if already loaded and not forcing refresh

    _isGraphLoading = true;
    notifyListeners();

    try {
      _graphData = await WasteService.fetchWasteGraph();
      print('Fetched Graph Data: $_graphData'); // Log the fetched data
    } catch (e) {
      throw Exception('Failed to fetch waste graph: $e');
    } finally {
      _isGraphLoading = false;
      notifyListeners();
    }
  }

  // Fetch both stats and graph data
  Future<void> fetchAllData({bool forceRefresh = false}) async {
    await fetchWasteStats(forceRefresh: forceRefresh);
    await fetchWasteGraph(forceRefresh: forceRefresh);
  }

  void clearData() {
    _totalWeight = 0;
    _wasteByType = {};
    _graphData = [];
    _isLoading = false;
    _isGraphLoading = false;
    notifyListeners();
  }

}