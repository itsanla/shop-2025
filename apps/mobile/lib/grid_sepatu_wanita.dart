import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'product_detail.dart';
import 'cart_page.dart';
import 'cart_service.dart';

class GridSepatuWanita extends StatefulWidget {
  const GridSepatuWanita({super.key});

  @override
  State<GridSepatuWanita> createState() => _GridSepatuWanitaState();
}

class _GridSepatuWanitaState extends State<GridSepatuWanita> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response = await http.get(Uri.parse('${dotenv.env['BASE_URL']}/products?category=sepatu wanita'));
    setState(() => products = json.decode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepatu Wanita', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())),
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(product: product))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(product['images'][0], height: 140, width: double.infinity, fit: BoxFit.cover),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      product['promo'] != null && product['promo'] > 0
                                          ? 'Rp ${(product['promo'] / 1000).toStringAsFixed(0)}k'
                                          : 'Rp ${(product['price'] / 1000).toStringAsFixed(0)}k',
                                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Icon(Icons.favorite, color: Colors.red, size: 16),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      context.read<CartService>().addItem(product);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product['name']} added'), duration: const Duration(seconds: 1)));
                                    },
                                    child: const Icon(Icons.shopping_cart, color: Colors.green, size: 16),
                                  ),
                                ],
                              ),
                              if (product['promo'] != null && product['promo'] > 0)
                                Text('Rp ${(product['price'] / 1000).toStringAsFixed(0)}k', style: const TextStyle(color: Colors.grey, fontSize: 10, decoration: TextDecoration.lineThrough)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
