import 'package:flutter/material.dart';

class AccountDetailsWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController stateController;

  const AccountDetailsWidget({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.stateController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(20),
        shadowColor: Colors.green.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.green[50]!,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Account Details'),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: nameController,
                  icon: Icons.person_outline_rounded,
                  labelText: 'Full Name',
                ),
                _buildTextField(
                  controller: emailController,
                  icon: Icons.email_outlined,
                  labelText: 'Email Address',
                ),
                _buildTextField(
                  controller: phoneController,
                  icon: Icons.phone_iphone_rounded,
                  labelText: 'Contact Number',
                ),
                _buildTextField(
                  controller: addressController,
                  icon: Icons.location_on_outlined,
                  labelText: 'Location',
                ),
                _buildTextField(
                  controller: stateController,
                  icon: Icons.flag_outlined,
                  labelText: 'State',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          height: 28,
          width: 6,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF64DD17)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 15),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
            fontFamily: 'Poppins',
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        cursorColor: const Color(0xFF2E7D32),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[50]!.withOpacity(0.4),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2E7D32),
              size: 22,
            ),
          ),
          filled: true,
          fillColor: Colors.green[50]!.withOpacity(0.15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.green[100]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF2E7D32),
              width: 1.8,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
              vertical: 16, horizontal: 20),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}