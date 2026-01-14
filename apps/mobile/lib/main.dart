import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'splashscreen.dart';
import 'auth_service.dart';
import 'cart_service.dart';
import 'transaction_service.dart';

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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => TransactionService()),
      ],
      child: MaterialApp(
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
              shape: const StadiumBorder(),
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
      ),
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
        // Selalu tampilkan SplashScreen dulu, tidak peduli login atau tidak
        return const SplashScreen();
      },
    );
  }
}