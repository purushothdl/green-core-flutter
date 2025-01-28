// lib/features/chat/widgets/chat_file_upload_widget.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

enum UploadType {
  image,
}

class ChatFileUploadWidget extends StatelessWidget {
  final Function(String? path, UploadType type) onFileSelected;

  const ChatFileUploadWidget({
    super.key,
    required this.onFileSelected,
  });

  Future<void> _pickImage(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty && result.files.single.path != null) {
        debugPrint("Selected image path: \${result.files.single.path}"); // Debug log
        onFileSelected(result.files.single.path!, UploadType.image);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.attach_file),
      onPressed: () => _pickImage(context),
    );
  }
}
