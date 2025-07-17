import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'cart_screen.dart';

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
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigate to the CartScreen using a MaterialPageRoute
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen()));
                },
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
                    final item = cartProvider.menuItemsData[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
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
                                if (cartProvider.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(cartProvider.errorMessage!), backgroundColor: Colors.red),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${item.name} added to cart!')),
                                  );
                                }
                              },
                              child: const Text('Add to Cart'),
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
                      'Total do Carrinho:',
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