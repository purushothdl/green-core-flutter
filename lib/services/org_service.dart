// lib/services/org_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../models/org_model.dart'; // You'll need to create this model
import '../utils/token_storage.dart'; // Assuming you have this utility to manage tokens

class OrgService {
  static Future<List<Org>> fetchOrgs() async {
    final token = await TokenStorage.getToken(); // Fetch the token from storage
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse(ApiEndpoints.getOrgs);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Adjust if needed
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print(data);
      return data.map((org) => Org.fromJson(org)).toList();
    } else {
      throw Exception('Failed to load orgs');
    }
  }

  // Submit rating for an organization using query parameters
  static Future<http.Response> submitRating(String orgId, int rating) async {
    final token = await TokenStorage.getToken(); // Fetch the token from storage
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('${ApiEndpoints.getOrgs}$orgId/rate')
        .replace(queryParameters: {'rating': '$rating'}); 

    final headers = {
      'Authorization': 'Bearer $token', // Include the token in the header
      'Content-Type': 'application/json', // Adjust if needed
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
      );

      // Check the response status
      if (response.statusCode == 200) {
        return response; // Successfully rated
      } else if (response.statusCode == 409) {
        throw Exception('You have already rated this organization'); // Already rated
      } else {
        throw Exception('Failed to submit rating'); // Other errors
      }
    } catch (e) {
      throw Exception('Failed to submit rating: $e');
    }
  }
}
