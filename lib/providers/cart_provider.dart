// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';

import '../models/menu_item.dart';

// Manages the shopping cart logic and calculations
class CartProvider with ChangeNotifier {
  final List<MenuItem> _items = [];
  String? _errorMessage;

  List<MenuItem> get items => [..._items]; // Returns a copy of cart items to prevent external modification
  String? get errorMessage => _errorMessage;

  // Predefined menu items available in the Bom Hamburguer shop
  final List<MenuItem> menuItemsData = [
    MenuItem(id: 's1', name: 'X Burger', price: 5.00, type: MenuItemType.sandwich),
    MenuItem(id: 's2', name: 'X Egg', price: 4.50, type: MenuItemType.sandwich),
    MenuItem(id: 's3', name: 'X Bacon', price: 7.00, type: MenuItemType.sandwich),
    MenuItem(id: 'e1', name: 'Fries', price: 2.00, type: MenuItemType.extra),
    MenuItem(id: 'e2', name: 'Soft Drink', price: 2.50, type: MenuItemType.extra),
  ];

  void addItem(MenuItem item) {
    _errorMessage = null; // Clears any previous error message

    // Checks for duplicate item types based on business rules
    bool alreadyHasSandwich = _items.any((cartItem) => cartItem.type == MenuItemType.sandwich);
    bool alreadyHasFries = _items.any((cartItem) => cartItem.name == 'Fries');
    bool alreadyHasSoftDrink = _items.any((cartItem) => cartItem.name == 'Soft Drink');

    if (item.type == MenuItemType.sandwich && alreadyHasSandwich) {
      _errorMessage = 'You can only add one sandwich to your order.';
    } else if (item.name == 'Fries' && alreadyHasFries) {
      _errorMessage = 'You can only add one portion of fries to your order.';
    } else if (item.name == 'Soft Drink' && alreadyHasSoftDrink) {
      _errorMessage = 'You can only add one soft drink to your order.';
    } else {
      _items.add(item); // Adds the item to the cart
    }
    notifyListeners(); // Notifies listeners of changes in the cart
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id); // Removes an item from the cart by its ID
    _errorMessage = null; // Clears error when item is removed
    notifyListeners(); // Notifies listeners of changes
  }

  void clearCart() {
    _items.clear(); // Clears all items from the cart
    _errorMessage = null;
    notifyListeners(); // Notifies listeners of changes
  }

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.price); // Calculates the sum of all item prices
  }

  double get discountAmount {
    double discount = 0.0;
    bool hasSandwich = _items.any((item) => item.type == MenuItemType.sandwich);
    bool hasFries = _items.any((item) => item.name == 'Fries');
    bool hasSoftDrink = _items.any((item) => item.name == 'Soft Drink');

    // Applies discounts based on specific combinations of items
    if (hasSandwich && hasFries && hasSoftDrink) {
      discount = subtotal * 0.20; // 20% discount for combo
    } else if (hasSandwich && hasSoftDrink) {
      discount = subtotal * 0.15; // 15% discount for sandwich + drink
    } else if (hasSandwich && hasFries) {
      discount = subtotal * 0.10; // 10% discount for sandwich + fries
    }
    return discount;
  }

  double get totalAmount {
    return subtotal - discountAmount; // Calculates the final total after discount
  }
}