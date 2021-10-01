import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:productosapp/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {

  final String _baseUrl = 'flutter-productos-df4cf-default-rtdb.firebaseio.com';
  final List<Product> prodcuts = [];

  final storage = new FlutterSecureStorage();

  Product selectedProduct;
  bool isLoading = true;
  bool isSaving = false;

  File newPictureFile;

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
      print(value);
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      this.prodcuts.add(tempProduct);
    });

    this.isLoading = false;
    notifyListeners();
    return this.prodcuts;

  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if( product.id == null ){
      await this.createProduct(product);
    } else {
      await this.updateProduct(product);
    }



    isSaving = false;
    notifyListeners();

  }

  Future<String> updateProduct( Product product) async {
    final url = Uri.https(_baseUrl,'products/${ product.id }.json');
    final resp = await http.put(url, body: product.toJson());
    // final decodeData = resp.body;

    final index = this.prodcuts.indexWhere((element) => element.id == product.id);
    this.prodcuts[index] = product;
  
    return product.id;
  }

   Future<String> createProduct( Product product) async {
    final url = Uri.https(_baseUrl,'products.json');
    final resp = await http.post(url, body: product.toJson());
    final decodeData = json.decode(resp.body);

    product.id = decodeData['name'];

    this.prodcuts.add(product);  
    return product.id;
  }

  void updateSelectedProductImage(String path) {
    this.selectedProduct.picture = path;
    this.newPictureFile = File.fromUri( Uri(path: path));
    notifyListeners();
  }

  Future<String> uploadImage() async {
    if( this.newPictureFile == null) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/drfbrudba/image/upload?upload_preset=vtp4m9jn');
    
    final imageUploadRequest = http.MultipartRequest('post',url);
    
    final file = await http.MultipartFile.fromPath('file', this.newPictureFile.path);

    imageUploadRequest.files.add(file);

    final streamedResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamedResponse);


    if( resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }

    this.newPictureFile = null;
    final decodeData = json.decode(resp.body);
    return decodeData['secure_url'];

  }

}