import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as ui;
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'auth_service.dart';
import 'asset_config.dart';
import 'email_verification_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Timer? _verificationTimer;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) setState(() {});
      _startVerificationPolling();
    });
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    super.dispose();
  }

  void _startVerificationPolling() {
    _verificationTimer?.cancel();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified && user.providerData.any((p) => p.providerId == 'password')) {
      _verificationTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        await FirebaseAuth.instance.currentUser?.reload();
        if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
          timer.cancel();
          if (mounted) {
            await AuthService.syncUserToBackend(FirebaseAuth.instance.currentUser!);
            setState(() {});
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: user == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_outline, size: 100, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text('Anda belum masuk', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text('Silakan masuk untuk melanjutkan', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(
                              providers: [
                                ui.EmailAuthProvider(),
                                GoogleProvider(clientId: dotenv.env['GOOGLE_CLIENT_ID'] ?? ''),
                                FacebookProvider(clientId: dotenv.env['FACEBOOK_APP_ID'] ?? ''),
                                ui.PhoneAuthProvider(),
                              ],
                              headerBuilder: (context, constraints, shrinkOffset) {
                                return Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Image.asset('assets/logo.png', height: 100),
                                );
                              },
                              subtitleBuilder: (context, action) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: action == AuthAction.signIn
                                      ? Text('Selamat datang! Silakan masuk untuk melanjutkan')
                                      : Text('Buat akun baru untuk mulai berbelanja'),
                                );
                              },
                              footerBuilder: (context, action) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    'Dengan masuk, Anda menyetujui syarat dan ketentuan kami',
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                              actions: [
                                AuthStateChangeAction<SignedIn>((context, state) async {
                                  if (state.user!.providerData.any((p) => p.providerId == 'password') && !state.user!.emailVerified) {
                                    if (context.mounted) Navigator.of(context).pop();
                                  } else {
                                    try {
                                      await AuthService.syncUserToBackend(state.user!);
                                    } catch (e) {}
                                    if (context.mounted) Navigator.of(context).pop();
                                  }
                                }),
                                AuthStateChangeAction<UserCreated>((context, state) async {
                                  await state.credential.user?.sendEmailVerification();
                                  if (context.mounted) Navigator.of(context).pop();
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: const Text('Masuk / Daftar'),
                    ),
                  ],
                ),
              ),
            )
          : user.providerData.any((p) => p.providerId == 'password') && !user.emailVerified
              ? const EmailVerificationPage()
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green,
                        backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                        child: user.photoURL == null
                            ? Text(
                                (user.displayName ?? user.email ?? 'U')[0].toUpperCase(),
                                style: const TextStyle(fontSize: 40, color: Colors.white),
                              )
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Text(user.displayName ?? 'User', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(user.email ?? user.phoneNumber ?? '', style: TextStyle(color: Colors.grey[600])),
                      if (user.emailVerified)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.verified, color: Colors.green, size: 16),
                              SizedBox(width: 4),
                              Text('Verified', style: TextStyle(color: Colors.green)),
                            ],
                          ),
                        ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (mounted) setState(() {});
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      ),
                    ],
                  ),
                ),
    );
  }
}
