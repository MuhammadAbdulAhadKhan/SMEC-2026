import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../providers/receipt_provider.dart';
import '../services/analytics_service.dart';
import '../widgets/summary_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final receiptProvider = Provider.of<ReceiptProvider>(context);
    final analyticsService = AnalyticsService();

    final monthlyData =
        analyticsService.monthlySummary(receiptProvider.receipts);
    final categoryData =
        analyticsService.categorySpending(receiptProvider.receipts);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SummaryCard(
              title: 'Total Expenses',
              value:
                  '\$${receiptProvider.totalExpenses.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 20),
            const Text('Monthly Spending',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
           SizedBox(
  height: 250,
  child: SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    series: <CartesianSeries<MapEntry<String, double>, String>>[
      ColumnSeries<MapEntry<String, double>, String>(
        dataSource: monthlyData.entries.toList(),
        xValueMapper: (data, _) => data.key,
        yValueMapper: (data, _) => data.value,
        color: const Color.fromARGB(255, 149, 149, 149),
      )
    ],
  ),
),
            const SizedBox(height: 20),
            const Text('Category Spending',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 250,
              child: SfCircularChart(
                series: <PieSeries<MapEntry<String, double>, String>>[
                  PieSeries<MapEntry<String, double>, String>(
                    dataSource: categoryData.entries.toList(),
                    xValueMapper: (data, _) => data.key,
                    yValueMapper: (data, _) => data.value,
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: true),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
