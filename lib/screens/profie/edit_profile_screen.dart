//lib/screens/profile/edit_profile_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:green_core/providers/profile_provider.dart';
import 'package:green_core/widgets/profile/edit_profile_image_widget.dart';
import 'package:green_core/widgets/profile/account_details_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _stateController;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _showSuccessMessage = false; // Add this line

  @override
  void initState() {
    super.initState();
    final user = Provider.of<ProfileProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name);
    _emailController = TextEditingController(text: user?.email);
    _phoneController = TextEditingController(text: user?.phone);
    _addressController = TextEditingController(text: user?.address);
    _stateController = TextEditingController(text: user?.state);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

Future<void> _updatePhoto() async {
  if (_image != null) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.uploadProfileImage(_image!);
    
    // Show success message
    setState(() {
      _showSuccessMessage = true;
    });

    // Hide the message after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showSuccessMessage = false;
        });
      }
    });
  }
}

  Future<void> _updateProfile() async {
    final userData = {
      if (_nameController.text.isNotEmpty) 'name': _nameController.text,
      if (_emailController.text.isNotEmpty) 'email': _emailController.text,
      if (_phoneController.text.isNotEmpty) 'phone': _phoneController.text,
      if (_addressController.text.isNotEmpty) 'address': _addressController.text,
      if (_stateController.text.isNotEmpty) 'state': _stateController.text,
    };

    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.updateUserDetails(userData);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProfileProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Wrap the Column in a SingleChildScrollView
        padding: const EdgeInsets.all(16.0), // Move padding here for consistency
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EditProfileImageWidget(
              user: user,
              image: _image,
              onSelectImage: _selectImage,
              onUpdatePhoto: _updatePhoto,
              showSuccessMessage: _showSuccessMessage,
            ),
            const SizedBox(height: 20),
            AccountDetailsWidget(
              nameController: _nameController,
              emailController: _emailController,
              phoneController: _phoneController,
              addressController: _addressController,
              stateController: _stateController,
            ),
            const SizedBox(height: 20), // Add spacing before buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8), // Add padding for better touch area
                    ),
                    child: const Text('Go Back'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8), // Add padding for better touch area
                    ),
                    child: const Text('Update Profile'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24), // Add bottom padding for better scrolling
          ],
        ),
      ),
    );
  }
}