// ini untuk sinkronisasi user Firebase ke backend buk
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class AuthService {
  // ini untuk kirim data user ke backend setelah login buk
  static Future<void> syncUserToBackend(User user) async {
    final baseUrl = dotenv.env['BASE_URL']!;
    
    await http.post(
      Uri.parse('$baseUrl/auth/verify'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName,
        'phone': user.phoneNumber,
      }),
    );
  }
}
