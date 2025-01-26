// lib/widgets/dashboard/custom_app_bar.dart
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../utils/string_utils.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User? user;

  const DashboardAppBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      title: Row(
        children: [
          // Profile Picture
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: user?.imageUrl != null
                  ? NetworkImage(user!.imageUrl!)
                  : const AssetImage('assets/header/default_icon.jpg') as ImageProvider,
            ),
          ),
          const SizedBox(width: 16),
          // Greeting and Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getGreeting(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user?.name ?? 'Loading...',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}