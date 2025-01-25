// lib/screens/auth/loading_screen.dart
import 'package:flutter/material.dart';
import '../../constants/api_endpoints.dart';
import '../../utils/token_storage.dart';
import '../../widgets/shared/loading_widget.dart';
import 'package:http/http.dart' as http;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final token = await TokenStorage.getToken();

    if (token != null) {
      // Token exists, verify it
      final isValid = await _verifyToken(token);

      if (isValid) {
        // Token is valid, navigate to dashboard
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Token is invalid, navigate to register
        Navigator.pushReplacementNamed(context, '/register');
      }
    } else {
      // No token, navigate to register
      Navigator.pushReplacementNamed(context, '/register');
    }
  }

  Future<bool> _verifyToken(String token) async {
    try {
      final url = Uri.parse(ApiEndpoints.me);
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoadingWidget(), 
      ),
    );
  }
}