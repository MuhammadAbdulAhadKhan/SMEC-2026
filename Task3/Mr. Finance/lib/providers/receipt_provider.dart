import 'package:flutter/material.dart';
import '../models/receipt.dart';

class ReceiptProvider with ChangeNotifier {
  List<Receipt> _receipts = [];

  List<Receipt> get receipts => _receipts;

  void addReceipt(Receipt receipt) {
    _receipts.add(receipt);
    notifyListeners();
  }

  double get totalExpenses =>
      _receipts.fold(0, (sum, item) => sum + item.totalAmount);
}
