// lib/widgets/chat_input_widget.dart
// lib/features/chat/widgets/chat_input_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'chat_file_upload_widget.dart';

class ChatInputWidget extends StatefulWidget {
  final bool enabled;
  final Function(String message, {String? imagePath}) onSendMessage;

  const ChatInputWidget({
    super.key,
    required this.enabled,
    required this.onSendMessage,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _controller = TextEditingController();
  String? _selectedImagePath;
  int _textFieldLines = 1; // Track the number of lines in the TextField

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_controller.text.trim().isEmpty && _selectedImagePath == null) return;
    widget.onSendMessage(
      _controller.text.trim(),
      imagePath: _selectedImagePath,
    );
    _controller.clear();
    setState(() {
      _selectedImagePath = null;
      _textFieldLines = 1; // Reset to 1 line after sending
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_selectedImagePath != null)
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildPreviewCard(
                    context,
                    _selectedImagePath!,
                    Icons.image,
                    Colors.purple,
                    () => setState(() => _selectedImagePath = null),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              ChatFileUploadWidget(
                onFileSelected: (path, type) => setState(() {
                  if (type == UploadType.image) {
                    _selectedImagePath = path;
                  }
                }),
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: _textFieldLines * 24.0 + 32.0, // Adjust height dynamically
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: null, // Allow unlimited lines
                    minLines: 1, // Start with 1 line
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (text) {
                      // Update the number of lines based on the text
                      final lines = (text.split('\n').length + text.split('').length ~/ 30);
                      setState(() {
                        _textFieldLines = lines.clamp(1, 5); // Limit to 5 lines max
                      });
                    },
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color.fromARGB(255, 231, 246, 213), Colors.green.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.send_rounded, color: Colors.green.shade600),
                  onPressed: widget.enabled ? _handleSend : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(BuildContext context, String path, IconData icon, Color color, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(File(path), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  path.split('/').last,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${File(path).lengthSync() / 1024 ~/ 1} KB',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.close_rounded, size: 16, color: Colors.grey.shade600),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
