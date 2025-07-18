// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'menu_screen.dart';
import '../providers/cart_provider.dart'; // Import CartProvider
import '../models/menu_item.dart';       // Import MenuItem model

// Home screen displayed after successful login
class HomeScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    // Use Consumer to access CartProvider's data, especially menuItemsData
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        // Select a few items for promotion.
        final List<MenuItem> promotionItems = [];
        if (cartProvider.menuItemsData.isNotEmpty) {
          // Example: Picking X Burger, X Egg, Fries, and Soft Drink for promotions
          promotionItems.add(cartProvider.menuItemsData[0]); // X Burger
          if (cartProvider.menuItemsData.length > 1) {
            promotionItems.add(cartProvider.menuItemsData[1]); // X Egg
          }
          if (cartProvider.menuItemsData.length > 3) {
            promotionItems.add(cartProvider.menuItemsData[3]); // Fries
          }
          if (cartProvider.menuItemsData.length > 4) {
            promotionItems.add(cartProvider.menuItemsData[4]); // Soft Drink
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Welcome to Bom Hamburguer!'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: onLogout, // Calls the logout function from AuthWrapper
              ),
            ],
          ),
          body: SingleChildScrollView( // Allows the entire body content to scroll vertically
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Align content to the start (top)
                crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
                children: [
                  const Text(
                    'You are logged in!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ready to order your delicious burger?',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the main ordering menu
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MenuScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50), // Make button a good size
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Start Ordering'),
                  ),
                  // --- Promotions Section (below Start Ordering, appears on scroll) ---
                  const SizedBox(height: 40), // Spacing before promotions
                  if (promotionItems.isNotEmpty) // Only show section if there are promotion items
                    Column(
                      children: [
                        const Text(
                          'Today\'s Promotions!', // Title for promotions section
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        // Display promotion items in a grid format
                        GridView.builder(
                          shrinkWrap: true, // Important: Makes GridView take only necessary space
                          physics: const NeverScrollableScrollPhysics(), // Important: Disables GridView's own scrolling
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 columns in the grid
                            crossAxisSpacing: 10.0, // Horizontal spacing between cards
                            mainAxisSpacing: 10.0, // Vertical spacing between cards
                            childAspectRatio: 0.7, // Aspect ratio of each item (width / height). Adjust as needed.
                          ),
                          itemCount: promotionItems.length,
                          itemBuilder: (context, index) {
                            final item = promotionItems[index];
                            return Card( // Each item is a Card in the grid
                              elevation: 5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column( // Column inside the card for image, text, and button
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Image for the promotion item
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        item.imageUrl,
                                        width: 100, // Fixed width for image in grid
                                        height: 100, // Fixed height for image in grid
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded( // Allows text to take available space
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                        maxLines: 2, // Allow two lines for longer names
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '\$${item.price.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 14, color: Colors.green),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        cartProvider.addItem(item);
                                        // --- Using AlertDialog instead of SnackBar ---
                                        if (cartProvider.errorMessage != null) {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text('Error Adding Item'), // Dialog title
                                              content: Text(cartProvider.errorMessage!), // Error message content
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Ok'), // Dialog button text
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop(); // Close dialog
                                                    cartProvider.clearErrorMessage(); // Clear the error in provider
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text('Item Added!'), // Dialog title
                                              content: Text('${item.name} has been added to cart.'), // Success message content
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Ok'), // Dialog button text
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop(); // Close dialog
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: const Text('Add'), // Button text
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: 20), // Spacing at the bottom of the scrollable content
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}