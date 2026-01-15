// ini untuk manage history transaksi pembayaran buk
import 'package:flutter/foundation.dart';

// ini class untuk data transaksi buk
class Transaction {
  final String orderId;
  final double totalPrice;
  final List<Map<String, dynamic>> items;
  final DateTime date;

  Transaction({required this.orderId, required this.totalPrice, required this.items, required this.date});
}

// ini service untuk simpan dan tampilkan history transaksi buk
class TransactionService extends ChangeNotifier {
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal();

  final List<Transaction> _transactions = [];

  // ini untuk ambil list semua transaksi buk
  List<Transaction> get transactions => _transactions;

  // ini untuk tambah transaksi baru setelah payment sukses buk
  void addTransaction(String orderId, double totalPrice, List<Map<String, dynamic>> items) {
    _transactions.insert(0, Transaction(orderId: orderId, totalPrice: totalPrice, items: items, date: DateTime.now()));
    notifyListeners();
  }
}
