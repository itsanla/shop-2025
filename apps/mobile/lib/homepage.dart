import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'gridelectronic.dart';
import 'product_detail.dart';
import 'cart_page.dart';
import 'cart_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products = [];
  PageController bannerController = PageController();
  int bannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _startBannerTimer();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('${dotenv.env['BASE_URL']}/products'));
      setState(() => products = json.decode(response.body));
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  void _startBannerTimer() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (bannerIndex < 2) bannerIndex++; else bannerIndex = 0;
      bannerController.animateToPage(bannerIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anla Online Shop', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () {}),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())),
          ),
          IconButton(icon: const Icon(Icons.camera_alt, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildBanner(),
            _buildCategories(),
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Product',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.filter_list, size: 20),
          filled: true,
          fillColor: Colors.green[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return SizedBox(
      height: 150,
      child: PageView(
        controller: bannerController,
        children: ['banner.png', 'banner2.png', 'banner3.png']
            .map((img) => Image.asset('lib/images/$img', fit: BoxFit.cover))
            .toList(),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'icon': 'electronics.png', 'name': 'Elektronik'},
      {'icon': 'man-shirt.png', 'name': 'Baju Pria'},
      {'icon': 'man-shoes.png', 'name': 'Sepatu Pria'},
      {'icon': 'woman-shirt.png', 'name': 'Dress'},
      {'icon': 'woman-shoes.png', 'name': 'Heels'},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Card(
            child: InkWell(
              onTap: () {
                if (cat['name'] == 'Elektronik') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GridElectronic()));
                }
              },
              child: Container(
                width: 70,
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('lib/images/${cat['icon']}', width: 40, height: 40),
                    const SizedBox(height: 4),
                    Text(cat['name']!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Text('Popular Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductDetail(product: product)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              product['images'][0],
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 140,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image, size: 50),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rp ${(product['price'] / 1000).toStringAsFixed(0)}k',
                                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.add_shopping_cart, size: 18, color: Colors.green),
                                        onPressed: () {
                                          CartService().addItem(product);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('${product['name']} added to cart'), duration: const Duration(seconds: 1)),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
