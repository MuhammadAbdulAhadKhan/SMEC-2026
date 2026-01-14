import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Map<String, dynamic>>> searchProduct(String query) async {
    List<Map<String, dynamic>> results = [];

    try {
      // ---------- FakeStore API ----------
      final fakeStoreRes =
          await http.get(Uri.parse("https://fakestoreapi.com/products"));
      if (fakeStoreRes.statusCode == 200) {
        final data = jsonDecode(fakeStoreRes.body);
        for (var p in data) {
          if (p['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())) {
            results.add({
              'name': p['title'],
              'price': (p['price'] as num).toDouble(),
              'website': 'ShopEase',
              'image': p['image'],
              'link': 'https://fakestoreapi.com',
            });
          }
        }
      }

      // ---------- DummyJSON ----------
      final dummyRes = await http.get(
        Uri.parse("https://dummyjson.com/products/search?q=$query"),
      );
      if (dummyRes.statusCode == 200) {
        final data = jsonDecode(dummyRes.body);
        for (var p in data['products']) {
          results.add({
            'name': p['title'],
            'price': (p['price'] as num).toDouble(),
            'website': 'QuickBuy',
            'image': p['thumbnail'],
            'link': 'https://dummyjson.com',
          });
        }
      }

      // ---------- Escuelajs ----------
      final escuelajsRes =
          await http.get(Uri.parse("https://api.escuelajs.co/api/v1/products"));
      if (escuelajsRes.statusCode == 200) {
        final data = jsonDecode(escuelajsRes.body);
        for (var p in data) {
          if (p['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())) {
            results.add({
              'name': p['title'],
              'price': (p['price'] as num).toDouble(),
              'website': 'MarketHub',
              'image': p['images'][0],
              'link': 'https://api.escuelajs.co',
            });
          }
        }
      }
    } catch (e) {
      debugPrint("API Error: $e");
    }

    return results;
  }
}
