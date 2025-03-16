// lib/router.dart
import 'package:flutter/material.dart';
import 'package:green_core/screens/chat/chat_screen.dart';
import 'package:green_core/screens/faqs%20and%20team/faq_screen.dart';
import 'package:green_core/screens/history/history_screen.dart';
import 'package:green_core/screens/home/chatbot_screen.dart';
import 'package:green_core/screens/home/home_screen.dart';
import 'package:green_core/screens/home/profile_screen.dart';
import 'package:green_core/screens/profie/edit_profile_screen.dart';
import 'screens/auth/loading_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'screens/home/orgs_screen.dart';
import 'package:provider/provider.dart';
import 'package:green_core/providers/waste_provider.dart';

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
        return MaterialPageRoute(builder: (_) => const ChatHistoryScreen());
      case '/chat':
        return MaterialPageRoute(builder: (_) => const ChatScreen());  
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/dispose':
        return MaterialPageRoute(builder: (_) => const OrgsScreen()); 
      
      case '/history':
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (context) => WasteProvider(),
            child: const HistoryScreen(),
          ),
        );

      case '/faqs':
        return MaterialPageRoute(builder: (_) => const FAQScreen()); 
      case '/edit_profile':
        return MaterialPageRoute(builder: (_) => const EditProfileScreen()); 
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}