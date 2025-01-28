import 'package:flutter/material.dart';
import '../../models/chat_model.dart';
import 'chat_message_widget.dart';

class ChatMessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController controller;

  const ChatMessageList({
    Key? key,
    required this.messages,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ChatMessageWidget(message: message);
      },
    );
  }
}
