// lib/providers/faq_provider.dart
import 'package:flutter/material.dart';
import '../services/faq_service.dart';
import '../models/faq_model.dart';

class FAQProvider with ChangeNotifier {
  Map<String, List<FAQ>> _faqs = {};
  bool _isLoading = false;
  String? _error;

  Map<String, List<FAQ>> get faqs => _faqs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFAQs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _faqs = await FAQService.fetchFAQs();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}