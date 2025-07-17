// lib/models/order.dart

import 'menu_item.dart';

class Order {
  final String id;
  final String customerName;
  final List<MenuItem> items;
  final double subtotal;
  final double discountAmount;
  final double totalAmount;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.discountAmount,
    required this.totalAmount,
    required this.orderDate,
  });

  // You might add toJson/fromJson methods here for persistence if needed in the future
}
