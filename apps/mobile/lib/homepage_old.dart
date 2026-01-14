import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'gridelectronic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchProduct = TextEditingController();
  PageController bannerController =PageController();
  List<dynamic> listProduct = [];
  Timer? bannerTamer;

  int indexBanner = 0;
  @override
  void initState() {
    super.initState();
    getProductItem();
    bannerOnBoarding();
  }

  @override
  void dispose() {
    bannerTamer?.cancel();
    bannerController.dispose();
    searchProduct.dispose();
    super.dispose();
  }

  void bannerOnBoarding() {
    bannerTamer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (indexBanner < 2) {
        indexBanner++;
      } else {
        indexBanner = 0;
      }
      bannerController.animateToPage(
        indexBanner,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> getProductItem() async {
    String baseUrl = dotenv.env['BASE_URL']!;
    String urlProductItem = "$baseUrl/products";
    try{
      var response = await http.get(Uri.parse(urlProductItem));
      setState((){
        listProduct = json.decode(response.body);
      });
    } catch(exc){
      if (kDebugMode){
        print(exc);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> bannerImage = [
      'lib/images/banner.png',
      'lib/images/banner2.png',
      'lib/images/banner3.png',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Anla Online Shop",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
            size: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 22,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget> [
            TextField(
              controller: searchProduct,
              decoration: const InputDecoration(
                hintText: 'Search Product',
                hintStyle: TextStyle(color: Colors.black),
                suffixIcon: Icon(
                  Icons.filter_list, 
                  size: 17, 
                  color: Colors.black,
                  ),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Color.fromARGB(255, 224, 239, 225),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 5,),
            SizedBox(height: 150,
            child: PageView.builder(
              controller: bannerController,
              itemCount: bannerImage.length,
              itemBuilder: (context, index){
                return Image.asset(bannerImage[index], fit: BoxFit.cover);
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: 90,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: <Widget> [
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                            builder: (context) => const GridElectronic(),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 80, 
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Image.asset('lib/images/electronics.png', width: 45, height: 45),
                              const Text(
                                "Electronik",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 80, 
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Image.asset('lib/images/man-shirt.png', width: 45, height: 45),
                              const Text(
                                "baju pria",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 80, 
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Image.asset('lib/images/man-shoes.png', width: 45, height: 45),
                              const Text(
                                "sepatu pria",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 80, 
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Image.asset('lib/images/woman-shirt.png', width: 45, height: 45),
                              const Text(
                                "dress",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {},
                        child: SizedBox(
                          height: 80, 
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Image.asset('lib/images/woman-shoes.png', width: 45, height: 45),
                              const Text(
                                "hills",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                  ],
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: <Widget> [
                    const Text(
                      "Popular Product",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if(listProduct.isEmpty)...[
                      const Center(
                        child: Text(
                          "No products available",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ]
                    else ... [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: 
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: listProduct.length,
                        itemBuilder: (context,index){
                          final productTotal = listProduct[index];
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 5,
                              child: Column(children: [
                                Image.network(
                                  productTotal['images'][0],
                                  height: 150,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 150,
                                      width: 120,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image, size: 50),
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(productTotal['name']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(Icons.favorite, color: Colors.red, size: 16),
                                      const SizedBox(width: 5),
                                      Text(
                                        '\Rp.${productTotal['price']}',
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          );
                        },
                      )
                    ]
                  ],
                ),
              ),
          ],
        )
      ),
    );
  }
}