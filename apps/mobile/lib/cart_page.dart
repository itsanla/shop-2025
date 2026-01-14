import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_service.dart';
import 'payment_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<CartService>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) return const Center(child: Text('Cart is empty'));
          
          return ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.network(item.image, width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(item.name),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red, size: 18),
                        onPressed: () => item.quantity > 1 ? cart.updateQuantity(item.id, item.quantity - 1) : null,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green, size: 18),
                        onPressed: () => cart.updateQuantity(item.id, item.quantity + 1),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Flexible(child: Text('Rp ${(item.price / 1000).toStringAsFixed(0)}k')),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => cart.removeItem(item.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartService>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) return const SizedBox.shrink();
          
          return Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${cart.totalItems} items'),
                    Text('Rp ${(cart.totalPrice / 1000).toStringAsFixed(0)}k', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: () {
                    if (FirebaseAuth.instance.currentUser == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please login to continue'), backgroundColor: Colors.red),
                      );
                      return;
                    }
                    final items = cart.items.map((item) => {
                      'id': item.id,
                      'name': item.name,
                      'price': item.price,
                      'quantity': item.quantity,
                    }).toList();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          totalPrice: cart.totalPrice,
                          items: items,
                        ),
                      ),
                    );
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
