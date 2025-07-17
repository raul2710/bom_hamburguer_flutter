// lib/main.dart
import 'package:bom_hamburguer_flutter/auth_service.dart';
import 'package:bom_hamburguer_flutter/providers/cart_provider.dart';
import 'package:bom_hamburguer_flutter/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs
import 'package:device_preview/device_preview.dart'; // For device preview functionality
import 'package:shared_preferences/shared_preferences.dart'; // For local storage
import 'dart:convert';

import 'auth_wrapper.dart'; // Required for JSON encoding/decoding

void main() async {
  // Ensures that the Flutter Binding is initialized before accessing SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview( // Adds DevicePreview for testing on different screen sizes
      enabled: true, // Set to false to disable in production builds
      builder: (context) => const MyApp(), // Wraps your main app widget
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()), // Provides authentication services
        ChangeNotifierProvider(create: (_) => CartProvider()), // Provides shopping cart management
        ChangeNotifierProvider(create: (_) => OrderProvider()), // Provides order management
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true, // Required for DevicePreview to work with media queries
        locale: DevicePreview.locale(context), // Sets the locale based on DevicePreview settings
        builder: DevicePreview.appBuilder, // Builds the app with DevicePreview's capabilities
        title: 'Bom Hamburguer App',
        debugShowCheckedModeBanner: false, // This line removes the debug banner
        theme: ThemeData(
          primarySwatch: Colors.red, // Sets the primary color for the app
          visualDensity: VisualDensity.adaptivePlatformDensity, // Adapts UI density based on platform
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.red, // AppBar background color
            foregroundColor: Colors.white, // AppBar text/icon color
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // ElevatedButton background color
              foregroundColor: Colors.white, // ElevatedButton text color
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // ElevatedButton text style
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners for buttons
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 4, // Card elevation for shadow effect
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Rounded corners for cards
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Margin around cards
          ),
        ),
        home: AuthWrapper(), // The starting point of the app, handling authentication flow
      ),
    );
  }
}