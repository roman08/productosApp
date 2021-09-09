import 'package:flutter/material.dart';
import 'package:productosapp/models/models.dart';



class ProductFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Product product;

  ProductFormProvider(this.product);  

  updateAvailability( bool value ) {
    this.product.available = value;
    notifyListeners();
  }
  
  bool isValidForm() {
    print(product.name);
    print(product.price);
    return formKey.currentState.validate() ?? false;
  }



}