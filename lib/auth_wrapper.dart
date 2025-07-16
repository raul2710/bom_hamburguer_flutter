// lib/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late AuthService _authService; // AuthService instance
  bool _isLoggedIn = false;
  bool _isLoading = true; // To show an initial loading indicator

  @override
  void initState() {
    super.initState();
    _authService = AuthService(); // Initializes AuthService
    _authService.addListener(_onAuthServiceChange); // Listens for changes in AuthService
    _checkLoginStatus(); // Checks login status when the widget initializes
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthServiceChange); // Removes the listener
    super.dispose();
  }

  void _onAuthServiceChange() {
    // When AuthService notifies a change, we re-check the login status
    _checkLoginStatus();
  }

  static const String _loggedInKey = 'isLoggedIn';

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool(_loggedInKey) ?? false; // Gets the value or false if it doesn't exist
      _isLoading = false; // Ends loading
    });
  }

  // Function to log in and save the status
  Future<bool> _login(String username, String password) async {
    if (_authService.checkCredentials(username, password)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loggedInKey, true);
      setState(() {
        _isLoggedIn = true;
      });
      return true;
    }
    return false;
  }

  // Function to log out and remove the status
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Shows a loading indicator while checking login
        ),
      );
    } else {
      return _isLoggedIn
          ? HomeScreen(onLogout: _logout) // If logged in, goes to the home screen
          : LoginScreen(
              onLogin: _login,
              onRegister: _authService.register, // Passes the register function from AuthService
              onResetPassword: _authService.resetPassword, // Passes the reset password function from AuthService
            );
    }
  }
}