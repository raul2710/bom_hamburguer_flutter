// lib/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

// Manages the overall authentication state and decides which screen to display (Login or Home)
class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;
  bool _isLoading =
      true; // Indicates whether the initial login status check is in progress

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Checks the login status when the widget is initialized
  }

  static const String _loggedInKey =
      'isLoggedIn'; // Key for storing login status in SharedPreferences

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn =
          prefs.getBool(_loggedInKey) ??
          false; // Retrieves login status, defaults to false
      _isLoading = false; // Loading is complete
    });
  }

  // Function to handle user login
  Future<bool> _login(String username, String password) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (authService.checkCredentials(username, password)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
        _loggedInKey,
        true,
      ); // Sets login status to true in local storage
      setState(() {
        _isLoggedIn = true; // Updates the local state to reflect login
      });
      return true;
    }
    return false; // Login failed
  }

  // Function to handle user logout
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey); // Removes login status from local storage
    setState(() {
      _isLoggedIn = false; // Updates the local state to reflect logout
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieves the AuthService instance to pass its methods to child screens
    final authService = Provider.of<AuthService>(context, listen: false);

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(), // Shows a loading indicator while checking login status
        ),
      );
    } else {
      return _isLoggedIn
          ? HomeScreen(
            onLogout: _logout,
          ) // If logged in, displays the HomeScreen
          : LoginScreen(
            onLogin: _login, // Passes the login function
            onRegister:
                authService
                    .register, // Passes the registration function from AuthService
            onResetPassword:
                authService
                    .resetPassword, // Passes the password reset function from AuthService
          );
    }
  }
}
