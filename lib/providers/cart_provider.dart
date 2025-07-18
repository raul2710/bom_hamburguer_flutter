// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';

import '../models/menu_item.dart'; // Import the updated MenuItem model

// Manages the shopping cart logic and calculations
class CartProvider with ChangeNotifier {
  final List<MenuItem> _items = [];
  String? _errorMessage;

  List<MenuItem> get items => [
        ..._items,
      ]; // Returns a copy of cart items to prevent external modification
  String? get errorMessage => _errorMessage;

  // Predefined menu items available in the Bom Hamburguer shop
  // Added imageUrls for display purposes in MenuScreen
  final List<MenuItem> menuItemsData = [
    MenuItem(
      id: 's1',
      name: 'X Burger',
      price: 5.00,
      type: MenuItemType.sandwich,
      imageUrl: 'assets/images/x_burguer.png',
    ),
    MenuItem(
      id: 's2',
      name: 'X Egg',
      price: 4.50,
      type: MenuItemType.sandwich,
      imageUrl: 'assets/images/egg_burguer.png',
    ),
    MenuItem(
      id: 's3',
      name: 'X Bacon',
      price: 7.00,
      type: MenuItemType.sandwich,
      imageUrl: 'assets/images/bacon_burguer.png',
    ),
    MenuItem(
      id: 'e1',
      name: 'Fries',
      price: 2.00,
      type: MenuItemType.extra,
      imageUrl: 'assets/images/fries.png',
    ),
    MenuItem(
      id: 'e2',
      name: 'Soft Drink',
      price: 2.50,
      type: MenuItemType.extra,
      imageUrl: 'assets/images/soft_drink.png',
    ),
  ];

  // Adds an item to the cart based on specific business rules
  void addItem(MenuItem item) {
    _errorMessage = null; // Clears any previous error message

    // Check for existing items of specific types
    bool alreadyHasSandwich = _items.any(
      (cartItem) => cartItem.type == MenuItemType.sandwich,
    );
    bool alreadyHasFries = _items.any((cartItem) => cartItem.name == 'Fries');
    bool alreadyHasSoftDrink = _items.any(
      (cartItem) => cartItem.name == 'Soft Drink',
    );

    // Apply business rules for adding items
    if (item.type == MenuItemType.sandwich && alreadyHasSandwich) {
      _errorMessage = 'You can only add one sandwich to your order.';
    } else if (item.name == 'Fries' && alreadyHasFries) {
      _errorMessage = 'You can only add one portion of fries to your order.';
    } else if (item.name == 'Soft Drink' && alreadyHasSoftDrink) {
      _errorMessage = 'You can only add one soft drink to your order.';
    } else {
      _items.add(item); // Adds the item to the cart if no rules are violated
    }
    notifyListeners(); // Notifies listeners of changes in the cart
  }

  // Removes an item from the cart by its ID
  void removeItem(String id) {
    _items.removeWhere(
      (item) => item.id == id,
    );
    _errorMessage = null; // Clear error message when an item is removed
    notifyListeners(); // Notifies listeners of changes
  }

  // Clears all items from the cart
  void clearCart() {
    _items.clear(); // Clears all items from the cart
    _errorMessage = null; // Clear error message
    notifyListeners(); // Notifies listeners of changes
  }

  /// Clears any current error message.
  /// This method can be explicitly called to reset the error state.
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners(); // Notify listeners to rebuild UI if necessary
  }

  // Calculates the subtotal of all items in the cart
  double get subtotal {
    return _items.fold(
      0.0,
      (sum, item) => sum + item.price,
    );
  }

  // Calculates the discount amount based on specific item combinations
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

  // Calculates the final total after discount
  double get totalAmount {
    return subtotal - discountAmount;
  }
}