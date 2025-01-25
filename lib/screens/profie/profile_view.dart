// lib/screens/profile/profile_view.dart
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/shared/refresh_indicator.dart';


class ProfileView extends StatefulWidget {
  final User? user;
  final Future<void> Function() onRefresh;

  const ProfileView({
    super.key,
    required this.user,
    required this.onRefresh,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isInitialLoad = true;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: widget.onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.user?.imageUrl != null)
                Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.user!.imageUrl!),
                    radius: 50,
                  ),
                ),
              const SizedBox(height: 20),
              _buildDetailItem('ID', widget.user?.id ?? 'N/A'),
              _buildDetailItem('Name', widget.user?.name ?? 'N/A'),
              _buildDetailItem('Email', widget.user?.email ?? 'N/A'),
              _buildDetailItem('Phone', widget.user?.phone ?? 'N/A'),
              _buildDetailItem('Address', widget.user?.address ?? 'N/A'),
              _buildDetailItem('State', widget.user?.state ?? 'N/A'),
              if (widget.user?.createdAt != null)
                _buildDetailItem(
                  'Joined On',
                  DateFormatter.format(widget.user!.createdAt!),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}