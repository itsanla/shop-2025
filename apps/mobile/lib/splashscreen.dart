// ini halaman splash screen yang tampil pertama kali waktu buka app buk
import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'asset_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ini untuk pindah ke onboarding setelah 2 detik buk
    Timer(const Duration(seconds: 2), () =>
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OnBoardingPage(),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ini logo aplikasi buk
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset('assets/logo.png', height: 140, width: 140, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Anla Online Shop',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}