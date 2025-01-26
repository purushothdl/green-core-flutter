// lib/services/org_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../models/org_model.dart'; // You'll need to create this model

class OrgService {
  static Future<List<Org>> fetchOrgs() async {
    final url = Uri.parse(ApiEndpoints.getOrgs);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print(data);
      return data.map((org) => Org.fromJson(org)).toList();
    } else {
      throw Exception('Failed to load orgs');
    }
  }
}