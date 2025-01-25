// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../models/user_model.dart';
import '../utils/token_storage.dart';

class AuthService {
  static Future<void> registerUser(User user) async {
    final url = Uri.parse(ApiEndpoints.register);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['detail'] ?? 'Registration failed';
      throw Exception(error);
    }
  }

  static Future<void> loginUser(String email, String password) async {
    final url = Uri.parse(ApiEndpoints.login);
    final request = http.MultipartRequest('POST', url)
      ..fields['email'] = email
      ..fields['password'] = password;

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final token = jsonDecode(responseData)['access_token'];
      await TokenStorage.saveToken(token);
    } else {
      final error = jsonDecode(responseData)['detail'] ?? 'Login failed';
      throw Exception(error);
    }
  }

  static Future<User> fetchUserDetails() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse(ApiEndpoints.me);
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      print(userData);
      return User.fromJson(userData);
    } else {
      throw Exception('Failed to fetch user details');
    }
  }

}