class Receipt {
  String id;
  String imageUrl;
  DateTime date;
  double totalAmount;
  Map<String, double> categories;

  Receipt({
    required this.id,
    required this.imageUrl,
    required this.date,
    required this.totalAmount,
    required this.categories,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'imageUrl': imageUrl,
        'date': date.toIso8601String(),
        'totalAmount': totalAmount,
        'categories': categories,
      };

  factory Receipt.fromMap(Map<String, dynamic> map) => Receipt(
        id: map['id'],
        imageUrl: map['imageUrl'],
        date: DateTime.parse(map['date']),
        totalAmount: map['totalAmount'],
        categories: Map<String, double>.from(map['categories']),
      );
}
