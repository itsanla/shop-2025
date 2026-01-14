import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
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
    
    final response = await http.post(
      Uri.parse('${dotenv.env['BASE_URL']}/payment/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'amount': widget.totalPrice.toInt(),
        'items': widget.items,
      }),
    );

    final data = json.decode(response.body);
    final snapUrl = 'https://app.sandbox.midtrans.com/snap/v2/vtweb/${data['snapToken']}';

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          if (url.contains('status_code=200') || url.contains('transaction_status=settlement') || url.contains('status_code=201')) {
            setState(() => isProcessing = true);
            context.read<TransactionService>().addTransaction(orderId, widget.totalPrice, widget.items);
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
}
