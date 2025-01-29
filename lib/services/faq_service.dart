// lib/services/faq_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../models/faq_model.dart';
import '../utils/token_storage.dart';

class FAQService {
  static Future<Map<String, List<FAQ>>> fetchFAQs() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final url = Uri.parse(ApiEndpoints.getFAQs);
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, List<FAQ>> faqsMap = {};
      jsonResponse.forEach((key, value) {
        faqsMap[key] = (value as List).map((faq) => FAQ.fromJson(faq)).toList();
      });
      return faqsMap;
    } else {
      throw Exception('Failed to fetch FAQs: ${response.statusCode}');
    }
  }
}