import 'package:aonecomparator/APIService.dart';
import 'package:aonecomparator/ProductCard.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController controller = TextEditingController();
  List<Map<String, dynamic>> products = [];
  bool loading = false;

  void search() async {
    setState(() => loading = true);
    products = await apiService.searchProduct(controller.text);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final best =
        products.isEmpty
            ? null
            : (products..sort((a, b) => a['price'].compareTo(b['price'])))
                .first;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text("Price Compare"),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search product...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[900],
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (loading)
              const CircularProgressIndicator(color: Colors.lightBlueAccent)
            else
              Expanded(
                child: ListView(
                  children:
                      products.map((p) {
                        return ProductCard(
                          name: p['name'],
                          price: p['price'],
                          website: p['website'],
                          image: p['image'],
                          link: p['link'],
                          isBest: p == best,
                        );
                      }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
