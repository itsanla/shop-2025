import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'homepage.dart';

class GridElectronic extends StatefulWidget {
  const GridElectronic({super.key});

  @override
  State<GridElectronic> createState() => _GridElectronicState();
}

class _GridElectronicState extends State<GridElectronic> {
  List<dynamic> listProduct = [];

  Future<void> getProductItem() async {
    String baseUrl = dotenv.env['BASE_URL']!;
    String urlProductItem = "$baseUrl/servershop_anla/allproductitem.php";
    try {
      var response = await http.get(Uri.parse(urlProductItem));
      setState(() {
        listProduct = json.decode(response.body);
      });
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getProductItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Electronic Product",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green.shade400,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart, color: Colors.white, size: 22),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
            ),
            itemCount: listProduct.length,
            itemBuilder: (context, index) {
              final item = listProduct[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailElectronic(item: item),
                  ),
                ),
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      Image.network(item['images'], height: 120, width: 150),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Text(
                              item['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 10,
                                        color: Colors.red.shade300,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Rp. ${item["price"]}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: Colors.red.shade300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (item['promo'] != 0)
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.price_check,
                                          size: 12,
                                          color: Colors.green.shade300,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Rp. ${item["promo"]}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Colors.green.shade300,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
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
        ),
      ),
    );
  }
}

class DetailElectronic extends StatelessWidget {
  const DetailElectronic({super.key, required this.item});
  final dynamic item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          item['name'],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green.shade400,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => GridElectronic()),
          ),
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart, color: Colors.white, size: 22),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Image.network(
              item['images'],
              height: 350,
              width: 400,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
            child: Text(
              "Product Description",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 5, 0, 5),
            child: Text(
              item['description'],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.black38,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Harga Rp. ${item["price"]}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.blue.shade700,
                  ),
                ),
                Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.favorite, color: Colors.red.shade700),
                    Text(
                      "Rp. ${item["promo"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(30),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Add To Cart',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}