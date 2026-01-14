import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/ocr_service.dart';
import '../models/receipt.dart';
import '../providers/receipt_provider.dart';
import '../services/analytics_service.dart';
import '../services/notification_service.dart';
import 'analytics_screen.dart';

class ScanReceiptScreen extends StatefulWidget {
  const ScanReceiptScreen({super.key});

  @override
  State<ScanReceiptScreen> createState() => _ScanReceiptScreenState();
}

class _ScanReceiptScreenState extends State<ScanReceiptScreen> {
  File? _image;
  bool _isProcessing = false;

  final OCRService _ocrService = OCRService();
  final AnalyticsService _analyticsService = AnalyticsService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isProcessing = true;
      });
      await _processImage(File(pickedFile.path));
    }
  }

  Future<void> _processImage(File image) async {
    String text = await _ocrService.extractText(image);

    double total = _parseTotalAmount(text);
    Map<String, double> categories = _categorizeExpenses(text);

    Receipt receipt = Receipt(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imageUrl: image.path,
      date: DateTime.now(),
      totalAmount: total,
      categories: categories,
    );

    Provider.of<ReceiptProvider>(context, listen: false).addReceipt(receipt);

    if (total > 100) {
      await _notificationService.showNotification(
          'High Expense Alert', 'You spent \$${total.toStringAsFixed(2)}!');
    }

    setState(() {
      _isProcessing = false;
    });

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
  }

  double _parseTotalAmount(String text) {
    RegExp regExp = RegExp(r'\d+\.\d{2}');
    Iterable<RegExpMatch> matches = regExp.allMatches(text);
    double maxAmount = 0;
    for (var match in matches) {
      double value = double.tryParse(match.group(0)!) ?? 0;
      if (value > maxAmount) maxAmount = value;
    }
    return maxAmount;
  }

  Map<String, double> _categorizeExpenses(String text) {
    Map<String, double> categories = {};
    if (text.toLowerCase().contains('food')) {
      categories['Food'] = _parseTotalAmount(text) * 0.5;
    }
    if (text.toLowerCase().contains('drink')) {
      categories['Drinks'] = _parseTotalAmount(text) * 0.2;
    }
    if (text.toLowerCase().contains('other')) {
      categories['Other'] = _parseTotalAmount(text) * 0.3;
    }
    if (categories.isEmpty) categories['Misc'] = _parseTotalAmount(text);
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Receipt'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Center(
        child: _isProcessing
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image != null
                      ? Image.file(_image!, width: 200)
                      : const Icon(Icons.receipt_long,
                          size: 100, color: Color.fromRGBO(138, 136, 136, 1)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Scan Receipt'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                  ),
                ],
              ),
      ),
    );
  }
}
