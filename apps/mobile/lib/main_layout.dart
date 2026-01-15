// ini layout utama dengan bottom navigation untuk pindah antar halaman buk
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'transaction_page.dart';
import 'profile.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  
  // ini list halaman yang bisa diakses dari bottom navigation buk
  final List<Widget> _pages = [
    const HomePage(),
    const TransactionPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ini untuk tampilkan halaman sesuai index yang dipilih buk
      body: _pages[_currentIndex],
      // ini bottom navigation bar untuk pindah halaman buk
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
