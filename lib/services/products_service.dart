import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:productosapp/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {

  final String _baseUrl = 'flutter-productos-df4cf-default-rtdb.firebaseio.com';
  final List<Product> prodcuts = [];
  Product selectedProduct;
  bool isLoading = true;

  ProductsService() {
    this.loadProducts();

  }

  Future<List<Product>> loadProducts() async {
    
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl,'products.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productMap = json.decode(resp.body);

    productMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      this.prodcuts.add(tempProduct);
    });

    this.isLoading = false;
    notifyListeners();
    return this.prodcuts;

  }

}