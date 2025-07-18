// lib/auth_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Required for json.encode and json.decode

// Handles user authentication logic (login, register, reset password) and user data storage
class AuthService extends ChangeNotifier {
  // Map to store users: {'username': 'password'}
  Map<String, String> _users = {};

  static const String _usersKey =
      'appUsers'; // Key for storing user data in SharedPreferences

  AuthService() {
    _loadUsers(); // Loads user data from local storage when the service is initialized
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null) {
      _users = Map<String, String>.from(json.decode(usersJson));
    } else {
      _users = {}; // Initializes as an empty map if no users are saved
    }
    notifyListeners(); // Notifies listeners that user data has been loaded
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _usersKey,
      json.encode(_users),
    ); // Saves user data to local storage
  }

  bool checkCredentials(String username, String password) {
    // Checks if the provided username exists and the password matches
    return _users.containsKey(username) && _users[username] == password;
  }

  Future<bool> register(String username, String password) async {
    // Checks if the username already exists
    if (_users.containsKey(username)) {
      return false; // User already exists, registration failed
    }
    _users[username] = password; // Adds the new user to the map
    await _saveUsers(); // Saves the updated user data to local storage
    notifyListeners(); // Notifies listeners that a new user has been added
    return true; // Registration successful
  }

  Future<bool> resetPassword(String username, String newPassword) async {
    // Checks if the user exists to reset their password
    if (_users.containsKey(username)) {
      _users[username] = newPassword; // Updates the user's password
      await _saveUsers(); // Saves the updated user data
      notifyListeners(); // Notifies listeners that the password has been reset
      return true;
    }
    return false; // User not found, password reset failed
  }
}
