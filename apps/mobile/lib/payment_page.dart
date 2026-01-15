import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'payment_detail_page.dart';
import 'transaction_service.dart';

class PaymentPage extends StatefulWidget {
  final double totalPrice;
  final List<Map<String, dynamic>> items;

  const PaymentPage({super.key, required this.totalPrice, required this.items});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  WebViewController? controller;
  bool isLoading = true;
  bool isProcessing = false;
  String orderId = '';

  @override
  void initState() {
    super.initState();
    _createTransaction();
  }

  Future<void> _createTransaction() async {
    orderId = 'ORDER-${DateTime.now().millisecondsSinceEpoch}';
    print('Order ID dibuat: $orderId');
    
    final response = await http.post(
      Uri.parse('${dotenv.env['BASE_URL']}/payment/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'orderId': orderId,
        'amount': widget.totalPrice.toInt(),
        'items': widget.items,
        'userEmail': FirebaseAuth.instance.currentUser?.email ?? 'guest@example.com',
      }),
    );

    if (response.statusCode != 200) {
      print('Gagal membuat payment: ${response.statusCode} - ${response.body}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create payment: ${response.body}')),
        );
        Navigator.pop(context);
      }
      return;
    }

    final data = json.decode(response.body);
    print('Response payment: $data');
    
    if (data['snapToken'] == null) {
      print('snapToken null');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get payment token')),
        );
        Navigator.pop(context);
      }
      return;
    }
    
    // ini untuk update orderId dari response backend biar sinkron buk
    if (data['orderId'] != null) {
      orderId = data['orderId'];
      print('Order ID dikonfirmasi: $orderId');
    }
    
    final snapUrl = 'https://app.sandbox.midtrans.com/snap/v2/vtweb/${data['snapToken']}';
    print('Snap URL: $snapUrl');

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          print('Payment URL: $url');
          
          // ini untuk cek berbagai kondisi sukses dari Midtrans buk
          final isSuccess = url.contains('status_code=200') || 
                           url.contains('status_code=201') ||
                           url.contains('transaction_status=settlement') ||
                           url.contains('transaction_status=capture') ||
                           url.contains('/finish?') ||
                           url.contains('&status_code=200') ||
                           url.contains('&transaction_status=settlement');
          
          if (isSuccess && !isProcessing) {
            print('Payment berhasil terdeteksi untuk order: $orderId');
            setState(() => isProcessing = true);
            context.read<TransactionService>().addTransaction(orderId, widget.totalPrice, widget.items);
            
            // ini untuk trigger notifikasi email ke backend buk
            _confirmPayment(orderId);
            
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentDetailPage(
                      orderId: orderId,
                      totalPrice: widget.totalPrice,
                      items: widget.items,
                    ),
                  ),
                );
              }
            });
          }
        },
      ))
      ..loadRequest(Uri.parse(snapUrl));

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                WebViewWidget(controller: controller!),
                if (isProcessing)
                  Container(
                    color: Colors.white,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.green),
                          SizedBox(height: 16),
                          Text('Processing payment...', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
  }

  Future<void> _confirmPayment(String orderId) async {
    try {
      print('Mengirim konfirmasi payment untuk: $orderId');
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/payment/confirm'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'order_id': orderId}),
      );
      print('Response konfirmasi: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        print('Payment dikonfirmasi dan email masuk queue');
      } else {
        print('Response tidak sesuai: ${response.body}');
      }
    } catch (e) {
      print('Error konfirmasi payment: $e');
    }
  }
}
