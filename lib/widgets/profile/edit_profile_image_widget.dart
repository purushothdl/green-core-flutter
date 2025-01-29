// lib/widgets/profile/edit_profile_image_widget.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:green_core/models/user_model.dart';
import 'package:green_core/utils/string_utils.dart';

class EditProfileImageWidget extends StatelessWidget {
  final User? user;
  final File? image;
  final VoidCallback onSelectImage;
  final VoidCallback onUpdatePhoto;
  final bool showSuccessMessage; // Add this line

  const EditProfileImageWidget({
    super.key,
    required this.user,
    required this.image,
    required this.onSelectImage,
    required this.onUpdatePhoto,
    required this.showSuccessMessage, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 111, 213, 116), Color.fromARGB(255, 60, 135, 64)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.green[50],
                        backgroundImage: image != null
                            ? FileImage(image!)
                            : user?.imageUrl != null
                                ? NetworkImage(user!.imageUrl!)
                                : null,
                        radius: 35,
                        child: image == null && user?.imageUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Color(0xFF2E7D32),
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.orange[400],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 8,
                            color: Colors.white,
                          ),
                          onPressed: onSelectImage,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'USERNAME',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        StringUtils.capitalizeFirstLetters(user?.name) ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (image != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: ElevatedButton(
                            onPressed: onUpdatePhoto,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 3,
                              shadowColor: Colors.grey.withOpacity(0.5),
                            ),
                            child: Text(
                              'Update Photo',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            // Add this Visibility widget for the success message
            Visibility(
              visible: showSuccessMessage,
              child: const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Photo updated successfully!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}