// lib/screens/home/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/profile/user_info_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isUserLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        authProvider.fetchUserDetails();
      });
    }
  }

  Future<void> _handleRefresh() async {
    await Provider.of<AuthProvider>(context, listen: false).fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
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
            Navigator.pushReplacementNamed(context, '/home'); 
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: authProvider.user == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: Colors.green,
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: UserInfoWidget(user: authProvider.user),
                ),
              ),
            ),
    );
  }
}