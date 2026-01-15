// ini halaman detail pembayaran yang sukses untuk tampilkan order ID dan item yang dibeli buk
import 'package:flutter/material.dart';

class PaymentDetailPage extends StatelessWidget {
  final String orderId;
  final double totalPrice;
  final List<Map<String, dynamic>> items;

  const PaymentDetailPage({super.key, required this.orderId, required this.totalPrice, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Detail', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ini card untuk tampilkan status pembayaran sukses buk
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 32),
                      const SizedBox(width: 12),
                      const Text('Payment Success', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 24),
                  Text('Order ID', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text('Total Amount', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  Text('Rp ${(totalPrice / 1000).toStringAsFixed(0)}k', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          // ini list item yang dibeli buk
          ...items.map((item) => Card(
            child: ListTile(
              title: Text(item['name']),
              subtitle: Text('${item['quantity']}x'),
              trailing: Text('Rp ${(item['price'] / 1000).toStringAsFixed(0)}k'),
            ),
          )),
          const SizedBox(height: 16),
          // ini tombol kembali ke home buk
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
