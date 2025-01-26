// lib/router.dart
import 'package:flutter/material.dart';
import 'package:green_core/screens/home/chatbot_screen.dart';
import 'package:green_core/screens/home/home_screen.dart';
import 'package:green_core/screens/home/profile_screen.dart';
import 'screens/auth/loading_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/dashboard_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoadingScreen()); // Initial route
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());  
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen()); 
      case '/chatbot':
        return MaterialPageRoute(builder: (_) => const ChatbotScreen());  
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen()); 
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}