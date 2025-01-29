// lib/services/profile_service.dart


import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import 'package:green_core/models/user_model.dart';
import 'package:green_core/utils/token_storage.dart';

class ProfileService {

  Future<User?> updateUserDetails(Map<String, dynamic> userData) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse(ApiEndpoints.me),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user details');
    }
  }

  Future<User?> uploadProfileImage(File image) async {
    final token = await TokenStorage.getToken();
    var request = http.MultipartRequest('POST', Uri.parse(ApiEndpoints.updateProfile));
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return User.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to upload profile image');
    }
  }
}