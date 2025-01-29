// lib/widgets/profile/user_info_widget.dart
import 'package:flutter/material.dart';
import 'package:green_core/utils/string_utils.dart';
import '../../models/user_model.dart';
import '../../utils/date_formatter.dart';

class UserInfoWidget extends StatelessWidget {
  final User? user;
  const UserInfoWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.green[50],
                      backgroundImage: user?.imageUrl != null 
                          ? NetworkImage(user!.imageUrl!) 
                          : null,
                      radius: 35,
                      child: user?.imageUrl == null
                          ? const Icon(Icons.person, size: 40, color: Color(0xFF2E7D32))
                          : null,
                    ),
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
                        const SizedBox(height: 4),
                        Text(
                          'Waste Management Hero',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Account Details'),
                      const SizedBox(height: 10),
                      _buildDetailItem(
                        icon: Icons.verified_user_rounded,
                        title: 'Member Since',
                        value: user?.createdAt != null 
                            ? DateFormatter.format(user!.createdAt!)
                            : 'N/A',
                        color: const Color(0xFF4CAF50),
                      ),
                      _buildDivider(),
                      _buildDetailItem(
                        icon: Icons.email_rounded,
                        title: 'Email Address',
                        value: user?.email ?? 'N/A',
                        color: const Color(0xFF81C784),
                      ),
                      _buildDivider(),
                      _buildDetailItem(
                        icon: Icons.phone_rounded,
                        title: 'Contact Number',
                        value: user?.phone ?? 'N/A',
                        color: const Color(0xFF66BB6A),
                      ),
                      _buildDivider(),
                      _buildDetailItem(
                        icon: Icons.location_pin,
                        title: 'Location',
                        value: user?.address != null
                            ? '${StringUtils.capitalizeFirstLetters(user!.address)} '
                            : 'N/A',
                        color: const Color(0xFFA5D6A7),
                      ),
                                            _buildDivider(),
                      _buildDetailItem(
                        icon: Icons.flag,
                        title: 'State',
                        value: user?.state != null
                            ? '${StringUtils.capitalizeFirstLetters(user!.state)}, India'
                            : 'N/A',
                        color: const Color(0xFFA5D6A7),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: 40,
    );
  }
}