// lib/main.dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:green_core/providers/chat_provider.dart';
import 'package:green_core/providers/dispose_provider.dart';
import 'package:green_core/providers/faq_provider.dart';
import 'package:green_core/providers/org_provider.dart';
import 'package:green_core/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/waste_provider.dart';
import 'router.dart';

void main() {
  final routeObserver = RouteObserver<ModalRoute<void>>();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WasteProvider()),
        ChangeNotifierProvider(create: (_) => OrgProvider()),
        ChangeNotifierProvider(create: (_) => DisposeProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => FAQProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        Provider<RouteObserver<ModalRoute<void>>>(create: (_) => routeObserver),
      ],
      child: MaterialApp(
        title: 'GreenCore',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
        navigatorObservers: [routeObserver], // Add routeObserver here
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenCore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}