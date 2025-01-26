// lib/services/waste_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../utils/token_storage.dart';

class WasteService {
  static Future<Map<String, dynamic>> fetchWasteStats() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse(ApiEndpoints.wasteStats);
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch waste stats');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchWasteGraph() async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception('No token found');

    final url = Uri.parse(ApiEndpoints.wasteGraph);
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch waste graph: ${response.statusCode}');
    }
  }

}