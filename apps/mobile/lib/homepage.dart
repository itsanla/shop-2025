import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'gridelectronic.dart';
import 'grid_baju_pria.dart';
import 'grid_baju_wanita.dart';
import 'grid_sepatu_pria.dart';
import 'grid_sepatu_wanita.dart';
import 'product_detail.dart';
import 'cart_page.dart';
import 'cart_service.dart';
import 'asset_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products = [];
  PageController bannerController = PageController();
  int bannerIndex = 0;
  Timer? _bannerTimer;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _startBannerTimer();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    bannerController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts([String? query]) async {
    final url = query != null && query.isNotEmpty
        ? '${dotenv.env['BASE_URL']}/search?q=$query'
        : '${dotenv.env['BASE_URL']}/products';
    final response = await http.get(Uri.parse(url));
    setState(() => products = json.decode(response.body));
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !bannerController.hasClients) return;
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
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: ClipOval(child: Image.asset('assets/logo.png', fit: BoxFit.cover)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: searchController,
                onChanged: (value) => _fetchProducts(value),
                decoration: InputDecoration(
                  hintText: 'Search Product',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.filter_list, size: 17),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 224, 239, 225),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: PageView(
                controller: bannerController,
                children: ['banner.png', 'banner2.png', 'banner3.png'].map((img) => Image.network(AssetConfig.getImageUrl(img), fit: BoxFit.cover)).toList(),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                children: [
                  {'icon': 'electronics.png', 'name': 'Elektronik', 'route': const GridElectronic()},
                  {'icon': 'man-shirt.png', 'name': 'Baju Pria', 'route': const GridBajuPria()},
                  {'icon': 'man-shoes.png', 'name': 'Sepatu Pria', 'route': const GridSepatuPria()},
                  {'icon': 'woman-shirt.png', 'name': 'Dress', 'route': const GridBajuWanita()},
                  {'icon': 'woman-shoes.png', 'name': 'Heels', 'route': const GridSepatuWanita()},
                ].map((cat) => Card(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => cat['route'] as Widget)),
                    child: Container(
                      width: 70,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(AssetConfig.getImageUrl(cat['icon'] as String), width: 40, height: 40),
                          Text(cat['name'] as String, style: const TextStyle(fontSize: 9)),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Popular Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            products.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 80, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            searchController.text.isEmpty ? 'Loading...' : 'Produk tidak ditemukan',
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8),
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
          ],
        ),
      ),
    );
  }
}
