// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import 'payment_screen.dart'; // Assuming PaymentScreen is correctly linked

// Shopping cart screen displaying selected items and total cost
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Consumer<CartProvider>( // Consumer rebuilds when CartProvider changes
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty. Start adding some delicious items!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return Card( // Use Card for better visual separation and design
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      elevation: 3, // Add a little shadow
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // --- Item Image ---
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0), // Rounded corners for the image
                              child: Image.network(
                                item.imageUrl, // Use the imageUrl from your MenuItem
                                width: 70, // Smaller size for cart items
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.fastfood, size: 35, color: Colors.grey),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10), // Spacing between image and text

                            // --- Item Name and Price ---
                            Expanded( // Allows text to take available space
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '\$${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),

                            // --- Remove Button ---
                            IconButton(
                              icon: const Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                cartProvider.removeItem(item.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // --- Cart Summary Section ---
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal:',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          '\$${cartProvider.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Discount:',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          '-\$${cartProvider.discountAmount.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white70, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    // Display error message if present in CartProvider
                    if (cartProvider.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          cartProvider.errorMessage!,
                          style: const TextStyle(color: Colors.yellowAccent, fontSize: 14), // Use a warning color
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Validate if a sandwich is in the cart before proceeding to payment
                        if (!cartProvider.items.any((item) => item.type == MenuItemType.sandwich)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a sandwich before proceeding to payment.'), backgroundColor: Colors.orange),
                          );
                          return;
                        }
                        // Clear any lingering error messages before navigating
                        cartProvider.clearErrorMessage();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Button background color
                        foregroundColor: Theme.of(context).primaryColor, // Button text color
                        minimumSize: const Size(double.infinity, 50), // Make button wide
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                        ),
                      ),
                      child: const Text(
                        'Proceed to Payment',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}