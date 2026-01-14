import 'package:intl/intl.dart';
import '../models/receipt.dart';

class AnalyticsService {
  Map<String, double> monthlySummary(List<Receipt> receipts) {
    Map<String, double> summary = {};
    for (var receipt in receipts) {
      String month = DateFormat('yyyy-MM').format(receipt.date);
      summary[month] = (summary[month] ?? 0) + receipt.totalAmount;
    }
    return summary;
  }

  Map<String, double> categorySpending(List<Receipt> receipts) {
    Map<String, double> categories = {};
    for (var receipt in receipts) {
      receipt.categories.forEach((key, value) {
        categories[key] = (categories[key] ?? 0) + value;
      });
    }
    return categories;
  }
}
