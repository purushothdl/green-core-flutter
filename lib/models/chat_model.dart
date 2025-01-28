// lib/features/chat/models/chat_model.dart
class ChatSession {
  final String sessionId;
  final String userId;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatSession({
    required this.sessionId,
    required this.userId,
    this.messages = const [], // Make messages optional and default to an empty list
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatSession.fromJson(Map json) {
    return ChatSession(
      sessionId: json['session_id'],
      userId: json['user_id'],
      messages: (json['messages'] as List?)
          ?.map((msg) => ChatMessage.fromJson(msg))
          .toList() ?? const [], // Handle null by defaulting to an empty list
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class ChatMessage {
  final String sender;
  final String text;
  final DateTime timestamp;
  final String? imagePath;
  final String? documentPath;

  bool get isUser => sender == 'user';

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
    this.imagePath,
    this.documentPath,
  });

  factory ChatMessage.fromJson(Map json) {
    return ChatMessage(
      sender: json['sender'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      imagePath: json['image_path'],
      documentPath: json['document_path'],
    );
  }
}