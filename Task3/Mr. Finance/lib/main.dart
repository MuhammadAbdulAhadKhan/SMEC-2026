import 'package:flutter/material.dart';
import 'package:mrfinancer/screens/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'providers/receipt_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ReceiptAnalyticsApp());
}

class ReceiptAnalyticsApp extends StatelessWidget {
  const ReceiptAnalyticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReceiptProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Receipt Analytics',
        theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.grey[100],
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
