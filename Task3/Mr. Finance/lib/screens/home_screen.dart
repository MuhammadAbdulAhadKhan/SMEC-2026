import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/receipt_provider.dart';
import 'scan_receipt_screen.dart';
import '../widgets/summary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final receiptProvider = Provider.of<ReceiptProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mr. Finance'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ScanReceiptScreen()));
        },
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        child: const Icon(Icons.camera_alt, color: Color.fromARGB(255, 255, 255, 255),),
        
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          SummaryCard(
            title: 'Total Expenses',
            value: '\$${receiptProvider.totalExpenses.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: receiptProvider.receipts
                  .map((r) => ListTile(
                        leading: Image.file(File(r.imageUrl), width: 50),
                        title: Text('\$${r.totalAmount.toStringAsFixed(2)}'),
                        subtitle: Text(r.date.toString().split(' ')[0]),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
