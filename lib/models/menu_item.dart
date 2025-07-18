// lib/models/menu_item.dart

enum MenuItemType {
  sandwich,
  extra,
}

class MenuItem {
  final String id;
  final String name;
  final double price;
  final MenuItemType type;
  final String imageUrl; // Added for image display in MenuScreen

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    // Provide a default or placeholder if imageUrl is not always available from your data source
    this.imageUrl = 'https://via.placeholder.com/100x100?text=Food',
  });
}