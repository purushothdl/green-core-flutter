// lib/services/dispose_service.dart
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../utils/token_storage.dart';

class DisposeService {
  static Future<void> disposeWaste({
    required String orgName,
    required String wasteType,
    required double weight,
    required File photo,
  }) async {
    final uri = Uri.parse(ApiEndpoints.disposeWaste);
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception('No token found');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['org_name'] = orgName
      ..fields['waste_type'] = wasteType
      ..fields['weight'] = weight.toString()
      ..files.add(await http.MultipartFile.fromPath('photo', photo.path));

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to dispose waste');
    }
  }
}
