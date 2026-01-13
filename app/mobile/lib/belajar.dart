import 'package:flutter/material.dart';

class Belajar extends StatefulWidget {
  const Belajar({super.key});

  @override
  State<Belajar> createState() => _BelajarState();
}

class _BelajarState extends State<Belajar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'aplikasi belajar',
          style: TextStyle(
            color: Color.fromARGB(255, 201, 196, 173),
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
        backgroundColor: Color.fromARGB(255, 43, 44, 45),
        centerTitle: true,
        elevation: 10,
        leading: IconButton(
          onPressed: (){}, 
          icon : const Icon(
            Icons.menu, 
            color: Colors.white
          )
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
    );
  }
}