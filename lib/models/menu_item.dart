// lib/models/menu_item.dart
enum MenuItemType { sandwich, extra }

class MenuItem {
  final String id;
  final String name;
  final double price;
  final MenuItemType type;

  MenuItem({required this.id, required this.name, required this.price, required this.type});
}
