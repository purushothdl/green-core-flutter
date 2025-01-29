// lib/providers/chat_provider.dart
import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatApiService _chatService = ChatApiService();
  ChatSession? _activeSession;
  List<ChatSession> _userChats = [];
  bool isLoading = false;
  bool _isInitialized = false;
  String? error;

  ChatSession? get activeSession => _activeSession;
  List<ChatSession> get userChats => _userChats;
  bool get isInitialized => _isInitialized;

    Future<void> loadUserChats(String userId, {bool forceReload = false}) async {
      if (_isInitialized && !forceReload) return;
      isLoading = true;
      _isInitialized = true;
      error = null;
      notifyListeners();
      try {
        _userChats = await _chatService.getUserChats(userId);
      } catch (e) {
        error = e.toString();
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  Future<void> loadChatSession(String sessionId) async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    _safeNotifyListeners();
    try {
      final session = await _chatService.getChatById(sessionId);
      if (session != _activeSession) {
        _activeSession = session;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> startChat({
    String? message,
    String? imagePath,
    String? documentPath,
  }) async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    _activeSession = null; // Clear active session before starting a new one
    _safeNotifyListeners();
    try {
      final session = await _chatService.startChat(
        message: message,
        imagePath: imagePath,
      );
      _activeSession = session;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> sendMessage(String message, {String? imagePath, String? documentPath}) async {
    if (_activeSession == null || isLoading) return;
    isLoading = true;
    error = null;
    _safeNotifyListeners();
    try {
      final updatedSession = await _chatService.continueChat(
        sessionId: _activeSession!.sessionId,
        message: message,
        imagePath: imagePath,
      );
      if (updatedSession != _activeSession) {
        _activeSession = updatedSession;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  void reset() {
    _activeSession = null;
    _userChats = [];
    isLoading = false;
    error = null;
    _safeNotifyListeners();
  }

  void clearActiveSession() {
    _activeSession = null;
    _safeNotifyListeners();
  }

  Future<void> deleteChat(String sessionId) async {
    isLoading = true;
    error = null;
    _safeNotifyListeners();
    try {
      await _chatService.deleteChatSession(sessionId);
      // Clear activeSession if it matches the deleted session
      if (_activeSession?.sessionId == sessionId) {
        _activeSession = null;
      }
      // Remove the chat from the list
      _userChats = _userChats.where((chat) => chat.sessionId != sessionId).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  // Helper method to safely notify listeners
  void _safeNotifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isDisposed) {
        notifyListeners();
      }
    });
  }

  // Track if the provider is disposed
  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}