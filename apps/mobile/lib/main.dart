import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'firebase_options.dart';
import 'splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    PhoneAuthProvider(),
    GoogleProvider(clientId: dotenv.env['GOOGLE_CLIENT_ID'] ?? ''),
    FacebookProvider(clientId: dotenv.env['FACEBOOK_APP_ID'] ?? ''),
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // KITA DEFINISIKAN WARNA UTAMA DISINI
    const primaryColor = Colors.deepPurple;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anla Online Shop',
      
      // --- BAGIAN INI YANG MENGUBAH UI BAWAAN JADI MODERN ---
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ),
        
        // 1. INPUT TEXT MODERN (Bulat & Filled)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16), // Sudut membulat
            borderSide: BorderSide.none, // Hilangkan garis border kasar
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),

        // 2. TOMBOL UTAMA (Sign In) JADI PILL SHAPE
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50), // Tombol tinggi
            shape: const StadiumBorder(), // Bentuk Pil
            elevation: 2,
          ),
        ),

        // 3. TOMBOL SOSMED (Google/FB) JADI BERSIH
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
      // -------------------------------------------------------

      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            // Kustomisasi Header agar lebih visual
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ganti Icon ini dengan Image.asset('assets/logo.png') kamu nanti
                    Icon(
                      Icons.shopping_bag_outlined, 
                      size: 80, 
                      color: Theme.of(context).colorScheme.primary
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Anla Online Shop",
                      style: TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Belanja hemat, barang berkualitas",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              );
            },
            
            // Mengubah teks subtitle default
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('Silakan masuk untuk melanjutkan.')
                    : const Text('Silakan buat akun baru.'),
              );
            },

            // Footer (Opsional: Copyright / Terms)
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    "By signing in, you agree to our Terms & Privacy",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              );
            },
          );
        }
        return const SplashScreen();
      },
    );
  }
}