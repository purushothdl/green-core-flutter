// lib/widgets/dispose/file_upload_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FileUploadWidget extends StatelessWidget {
  final String label;
  final String? filePath;
  final Function(String?) onFileSelected;

  const FileUploadWidget({
    super.key,
    required this.label,
    this.filePath,
    required this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isImage = filePath != null &&
        (filePath!.toLowerCase().endsWith('.jpg') ||
            filePath!.toLowerCase().endsWith('.jpeg') ||
            filePath!.toLowerCase().endsWith('.png'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(source: ImageSource.gallery);

            if (pickedFile != null) {
              final imagePath = pickedFile.path;
              onFileSelected(imagePath); // Provide the selected image path
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blueGrey.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                if (filePath == null)
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 40,
                    color: Colors.blueGrey[300],
                  ),
                if (filePath != null && isImage)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(filePath!), // Use Image.file to load from file path
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  filePath == null
                      ? 'Tap to upload $label'
                      : 'Tap to change $label',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey[600],
                  ),
                ),
                if (filePath != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Selected file: ${filePath!.split('/').last}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey[400],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
