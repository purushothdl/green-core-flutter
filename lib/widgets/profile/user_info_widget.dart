// lib/widgets/profile/user_info_widget.dart
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../utils/date_formatter.dart';

class UserInfoWidget extends StatelessWidget {
  final User? user;

  const UserInfoWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (user?.imageUrl != null)
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(user!.imageUrl!),
              radius: 50,
            ),
          ),
        const SizedBox(height: 20),
        _buildDetailRow(Icons.person, 'Name', user?.name ?? 'N/A'),
        _buildDetailRow(Icons.email, 'Email', user?.email ?? 'N/A'),
        _buildDetailRow(Icons.phone, 'Phone', user?.phone ?? 'N/A'),
        _buildDetailRow(Icons.home, 'Address', user?.address ?? 'N/A'),
        _buildDetailRow(Icons.location_city, 'State', user?.state ?? 'N/A'),
        if (user?.createdAt != null)
          _buildDetailRow(
            Icons.calendar_today,
            'Joined On',
            DateFormatter.format(user!.createdAt!),
          ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}