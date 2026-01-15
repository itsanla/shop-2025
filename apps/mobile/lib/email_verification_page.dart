// ini halaman untuk verifikasi email setelah daftar pakai email buk
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'auth_service.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // ini untuk cek verifikasi email setiap 3 detik buk
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
        timer.cancel();
        if (mounted) {
          await AuthService.syncUserToBackend(FirebaseAuth.instance.currentUser!);
          if (mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email_outlined, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text('Cek Email Anda', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                'Email verifikasi telah dikirim ke\n${FirebaseAuth.instance.currentUser?.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: Colors.green),
              const SizedBox(height: 15),
              const Text('Menunggu verifikasi...', style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 30),
              // ini tombol untuk kirim ulang email verifikasi buk
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email verifikasi dikirim ulang!')),
                    );
                  }
                },
                child: const Text('Kirim Ulang Email'),
              ),
              // ini tombol untuk logout dan daftar dengan cara lain buk
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Daftar dengan cara lain'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
