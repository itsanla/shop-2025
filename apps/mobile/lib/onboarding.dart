import 'package:flutter/material.dart';
import 'main_layout.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  PageController boardingController =PageController();
  int indexPage = 0;

  List<Map<String, String>> dataAan = [
    {
      "title":"Welcome to Anla Shop",
      "subTittle":"Discover various quality product in our store",
      "image":"https://i.pinimg.com/736x/7a/f9/f8/7af9f8b2e5bd6efd5fda10ef99ebb127.jpg"
    },
    {
      "title":"Electronics",
      "subTittle":"Find the latest gadgets and electronic devices",
      "image":"https://cdn.dummyjson.com/product-images/smartphones/iphone-5s/1.webp"
    },
    {
      "title":"Men's Clothing",
      "subTittle":"Stylish shirts and apparel for men",
      "image":"https://cdn.dummyjson.com/product-images/mens-shirts/men-check-shirt/1.webp"
    },
    {
      "title":"Men's Shoes",
      "subTittle":"Comfortable and trendy footwear for men",
      "image":"https://cdn.dummyjson.com/product-images/mens-shoes/puma-future-rider-trainers/1.webp"
    },
    {
      "title":"Women's Dress",
      "subTittle":"Elegant dresses for every occasion",
      "image":"https://cdn.dummyjson.com/product-images/tops/girl-summer-dress/1.webp"
    },
    {
      "title":"Women's Heels",
      "subTittle":"Beautiful heels to complete your look",
      "image":"https://cdn.dummyjson.com/product-images/womens-shoes/calvin-klein-heel-shoes/1.webp"
    },
    {
      "title":"Get started",
      "subTittle":"begin your shopping experient",
      "image":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvPh9hd-Nonod-jOedev2EWsldcuYjabXayQ&s"
    },
  ];

  @override
  void initState() {
    super.initState();
    boardingController = PageController();
    boardingController.addListener(() {
      setState(() {
        indexPage = boardingController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    boardingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget> [
          Expanded(
            child: PageView.builder(
              controller: boardingController,
              itemCount: dataAan.length,
              itemBuilder: (context, index){
                return OnboardingLayout(
                  title: "${dataAan[index]['title']}",
                  subTittle: "${dataAan[index]['subTittle']}",
                  image: "${dataAan[index]['image']}",
                );
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                const SizedBox(width: 48),
                Row(
                  children: List.generate(
                    dataAan.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: indexPage == index ? Colors.green : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: (){
                      if(indexPage == dataAan.length - 1){
                        Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                builder: (context) => const MainLayout(),
                                ),
                        );
                      }
                      else{
                        boardingController.nextPage(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: const Icon(Icons.arrow_forward, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingLayout extends StatelessWidget {
  const OnboardingLayout({
    super.key,
    required this.title, 
    required this.subTittle,
    required this.image
  });
  final String title;
  final String subTittle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        Image.network(image, height: 350, width: 300,),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 10),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
            subTittle,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}