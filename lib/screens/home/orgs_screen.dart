// lib/screens/home/orgs_screen.dart
import 'package:flutter/material.dart';

class OrgsScreen extends StatelessWidget {
  const OrgsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Organizations',
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
      body: const Center(
        child: Text('This is the Orgs screen'),
      ),
    );
  }
}