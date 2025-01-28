// lib/features/chat/screens/widgets/chat_history/chat_history_list.dart
import 'package:flutter/material.dart';
import '../../providers/chat_provider.dart';
import 'chat_history_item.dart';

class ChatHistoryList extends StatelessWidget {
  final ChatProvider chatProvider;
  const ChatHistoryList({super.key, required this.chatProvider});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatProvider.userChats.length,
      itemBuilder: (context, index) {
        final chat = chatProvider.userChats[index];
        return ChatHistoryItem(chat: chat);
      },
    );
  }
}