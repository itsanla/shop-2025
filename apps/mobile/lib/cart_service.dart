// ini untuk manage keranjang belanja buk
import 'package:flutter/foundation.dart';

// ini class untuk item yang ada di keranjang buk
class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItem({required this.id, required this.name, required this.price, required this.image, this.quantity = 1});
}

// ini service untuk handle semua operasi keranjang buk
class CartService extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  // ini untuk ambil list semua item di keranjang buk
  List<CartItem> get items => _items.values.toList();
  
  // ini untuk hitung total jumlah item buk
  int get totalItems => _items.values.fold(0, (sum, item) => sum + item.quantity);
  
  // ini untuk hitung total harga semua item buk
  double get totalPrice => _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  // ini untuk tambah produk ke keranjang buk
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

  // ini untuk hapus item dari keranjang buk
  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  // ini untuk update jumlah quantity item buk
  void updateQuantity(String id, int quantity) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity = quantity;
      notifyListeners();
    }
  }

  // ini untuk kosongkan keranjang setelah checkout buk
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
