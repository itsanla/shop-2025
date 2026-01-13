import 'dart:async';
import 'package:flutter/material.dart';
import 'gridelectronic.dart';
import 'homepage.dart';
import 'onboarding.dart';

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
        child: Image.asset('lib/images/shoppingchart.png', scale: 1.2),
      ),
    );
  }
}