// lib/main.dart
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart'; // Imports the device_preview package
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_wrapper.dart'; // Imports the package for initialization

void main() async {
  // Ensures that the Flutter Binding is initialized before accessing SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview( // Adds DevicePreview here
      enabled: true, // Set to false to disable in production
      builder: (context) => const MyApp(), // Wraps your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context), // Required for DevicePreview
      builder: DevicePreview.appBuilder, // Required for DevicePreview
      title: 'Login with Local Storage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthWrapper(), // Uses a wrapper to manage authentication state
    );
  }
}
