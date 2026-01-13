import 'dart:async';
import 'package:flutter/material.dart';
import 'gridelectronic.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () =>
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const GridElectronic(),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('https://i.pinimg.com/736x/7a/f9/f8/7af9f8b2e5bd6efd5fda10ef99ebb127.jpg', scale: 1.2),
      ),
    );
  }
}