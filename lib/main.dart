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
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized

  // Request location permissions and get the current location
  await requestLocationPermission();

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

Future<void> requestLocationPermission() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, prompt the user to enable them
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, handle accordingly
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are permanently denied, handle accordingly
    return;
  }

  // If permissions are granted, you can now get the current location
  Position position = await Geolocator.getCurrentPosition();
  print("Location: ${position.latitude}, ${position.longitude}");
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