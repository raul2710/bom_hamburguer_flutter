// lib/providers/order_provider.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs

import '../models/menu_item.dart';
import '../models/order.dart'; // For generating unique IDs

// Manages past orders
class OrderProvider with ChangeNotifier {
  final List<Order> _pastOrders = [];
  final Uuid _uuid = Uuid(); // Instance to generate unique IDs for orders

  List<Order> get pastOrders => [
    ..._pastOrders,
  ]; // Returns a copy of past orders

  void placeOrder(
    String customerName,
    List<MenuItem> cartItems,
    double subtotal,
    double discount,
    double total,
  ) {
    final newOrder = Order(
      id: _uuid.v4(), // Generates a unique UUID for the new order
      customerName: customerName,
      items: List.from(cartItems), // Creates a copy of cart items for the order
      subtotal: subtotal,
      discountAmount: discount,
      totalAmount: total,
      orderDate: DateTime.now(), // Sets the current date/time for the order
    );
    _pastOrders.add(newOrder); // Adds the new order to the list of past orders
    notifyListeners(); // Notifies listeners that a new order has been placed
    // Here you would typically add logic to persist orders (e.g., shared_preferences, sqflite)
  }
}
