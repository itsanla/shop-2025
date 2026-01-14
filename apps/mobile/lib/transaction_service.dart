import 'package:flutter/foundation.dart';

class Transaction {
  final String orderId;
  final double totalPrice;
  final List<Map<String, dynamic>> items;
  final DateTime date;

  Transaction({required this.orderId, required this.totalPrice, required this.items, required this.date});
}

class TransactionService extends ChangeNotifier {
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal();

  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  void addTransaction(String orderId, double totalPrice, List<Map<String, dynamic>> items) {
    _transactions.insert(0, Transaction(orderId: orderId, totalPrice: totalPrice, items: items, date: DateTime.now()));
    notifyListeners();
  }
}
