// lib/main.dart
import 'package:flutter/material.dart';
import 'package:green_core/providers/org_provider.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/waste_provider.dart';
import 'router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WasteProvider()),
        ChangeNotifierProvider(create: (_) => OrgProvider()),
      ],
      child: const MyApp(),
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