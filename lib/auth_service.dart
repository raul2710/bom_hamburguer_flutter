// lib/auth_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Required for json.encode and json.decode

class AuthService extends ChangeNotifier {
  // Map to store users: {'username': 'password'}
  Map<String, String> _users = {};

  static const String _usersKey = 'appUsers'; // Key to store all users

  AuthService() {
    _loadUsers(); // Loads users when the service starts
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null) {
      _users = Map<String, String>.from(json.decode(usersJson));
    } else {
      _users = {}; // Initializes as an empty map if no users are saved
    }
    notifyListeners(); // Notifies listeners that users have been loaded
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, json.encode(_users));
  }

  bool checkCredentials(String username, String password) {
    // Checks if the user exists and the password is correct
    return _users.containsKey(username) && _users[username] == password;
  }

  Future<bool> register(String username, String password) async {
    // Checks if the user already exists
    if (_users.containsKey(username)) {
      return false; // User already exists
    }
    _users[username] = password;
    await _saveUsers(); // Saves the updated users to local storage
    notifyListeners(); // Notifies listeners that a new user has been added
    return true; // Registration successful
  }

  Future<bool> resetPassword(String username, String newPassword) async {
    if (_users.containsKey(username)) {
      _users[username] = newPassword; // Updates the password
      await _saveUsers(); // Saves the changes
      notifyListeners(); // Notifies listeners that the password has been reset
      return true;
    }
    return false; // User not found
  }
}