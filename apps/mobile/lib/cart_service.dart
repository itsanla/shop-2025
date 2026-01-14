import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItem({required this.id, required this.name, required this.price, required this.image, this.quantity = 1});
}

class CartService extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();
  int get totalItems => _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  void addItem(Map<String, dynamic> product) {
    final price = (product['promo'] != null && product['promo'] > 0) ? product['promo'].toDouble() : product['price'].toDouble();
    
    if (_items.containsKey(product['id'])) {
      _items[product['id']]!.quantity++;
    } else {
      _items[product['id']] = CartItem(
        id: product['id'],
        name: product['name'],
        price: price,
        image: product['images'][0],
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity = quantity;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
