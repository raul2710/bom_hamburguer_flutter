// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

import 'menu_screen.dart';

// Home screen displayed after successful login
class HomeScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Bom Hamburguer!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout, // Calls the logout function from AuthWrapper
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are logged in!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ready to order your delicious burger?',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigate to the main ordering menu
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MenuScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50), // Make button a good size
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Start Ordering'),
            ),
          ],
        ),
      ),
    );
  }
}