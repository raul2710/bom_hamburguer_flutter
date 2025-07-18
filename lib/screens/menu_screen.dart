// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart'; // Assuming CartScreen is in 'lib/screens/cart_screen.dart'
import '../models/menu_item.dart'; // Import MenuItem model

// Menu screen displaying available sandwiches and extras
class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use Consumer to rebuild only the necessary parts when CartProvider changes
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Bom Hamburguer Menu'),
            actions: [
              // Shopping Cart Icon with Item Count Badge
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      // Navigate to the CartScreen using a MaterialPageRoute
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen()));
                    },
                  ),
                  // Display badge only if there are items in the cart
                  if (cartProvider.items.isNotEmpty)
                    Positioned(
                      right: 5, // Adjust positioning as needed
                      top: 5,   // Adjust positioning as needed
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red, // Badge color
                          borderRadius: BorderRadius.circular(10), // Makes it circular
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16, // Minimum width of the badge
                          minHeight: 16, // Minimum height of the badge
                        ),
                        child: Text(
                          cartProvider.items.length.toString(), // Display item count
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              // No direct logout button here, as logout is handled from HomeScreen
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.menuItemsData.length, // Uses menuItemsData from CartProvider
                  itemBuilder: (context, index) {
                    final MenuItem item = cartProvider.menuItemsData[index]; // Use MenuItem type
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row( // Use Row to place image next to text and button
                          crossAxisAlignment: CrossAxisAlignment.center, // Vertically align content
                          children: [
                            // Add the image here
                            ClipRRect( // For rounded corners on the image
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                item.imageUrl, // Use the image URL from the MenuItem
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback widget if image fails to load
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16.0), // Spacing between image and text
                            Expanded( // Allows text and button column to take remaining space
                              child: Row( // Keep original Row for name/price and button
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      cartProvider.addItem(item);
                                      // Check for error message immediately after trying to add
                                      if (cartProvider.errorMessage != null) {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Error Adding Item'),
                                            content: Text(cartProvider.errorMessage!),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Ok'),
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                  // Clear the error message in the provider after it's been displayed
                                                  cartProvider.clearErrorMessage();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Item Added'),
                                            content: Text('${item.name} has been added to cart!'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Ok'),
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Add to Cart'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Persistent bottom container for total value
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, // Use primary color for the bar
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, -3), // Shadow at the top
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Cart Total:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}