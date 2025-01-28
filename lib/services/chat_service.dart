// lib/services/chat_service.dart
// lib/core/services/api/chat_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/api_endpoints.dart';
import '../models/chat_model.dart';
import '../utils/token_storage.dart';

class ChatApiService {

  Future<List<ChatSession>> getUserChats(String userId) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.getChats),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((chat) => ChatSession.fromJson(chat)).toList();
      } else {
        throw Exception('Failed to load chats');
      }
    } catch (e) {
      throw Exception('Error fetching chats: $e');
    }
  }

  Future<ChatSession> getChatById(String sessionId) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.getChat}/$sessionId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return ChatSession.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load chat session');
      }
    } catch (e) {
      throw Exception('Error fetching chat session: $e');
    }
  }

  Future<ChatSession> startChat({
    String? message,
    String? imagePath,
  }) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiEndpoints.startChat),
    );
    request.headers.addAll({'Authorization': 'Bearer $token'});
    if (message != null && message.isNotEmpty) {
      request.fields['message'] = message;
    }
    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return ChatSession.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to start chat');
      }
    } catch (e) {
      throw Exception('Error starting chat: $e');
    }
  }

  Future<ChatSession> continueChat({
    required String sessionId,
    required String message,
    String? imagePath,
  }) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiEndpoints.continueChat),
    );
    request.headers.addAll({'Authorization': 'Bearer $token'});
    request.fields['session_id'] = sessionId;
    if (message.isNotEmpty) {
      request.fields['message'] = message;
    }
    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return ChatSession.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to continue chat');
      }
    } catch (e) {
      throw Exception('Error continuing chat: $e');
    }
  }

  Future<void> deleteChatSession(String sessionId) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    try {
      final response = await http.delete(
        Uri.parse('${ApiEndpoints.endChat}/$sessionId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete chat session');
      }
    } catch (e) {
      throw Exception('Error deleting chat session: $e');
    }
  }
}