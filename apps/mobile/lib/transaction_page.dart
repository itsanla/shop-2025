import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transaction_service.dart';
import 'payment_detail_page.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<TransactionService>(
        builder: (context, service, child) {
          if (service.transactions.isEmpty) {
            return const Center(child: Text('No transactions yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: service.transactions.length,
            itemBuilder: (context, index) {
              final tx = service.transactions[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.receipt_long, color: Colors.green),
                  title: Text(tx.orderId),
                  subtitle: Text('${tx.items.length} items • Rp ${(tx.totalPrice / 1000).toStringAsFixed(0)}k'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentDetailPage(
                        orderId: tx.orderId,
                        totalPrice: tx.totalPrice,
                        items: tx.items,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
