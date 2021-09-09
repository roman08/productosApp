import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:productosapp/models/models.dart';
import 'package:productosapp/screens/screens.dart';
import 'package:productosapp/services/services.dart';
import 'package:productosapp/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productSercive = Provider.of<ProductsService>(context);

    if( productSercive.isLoading ) return LoadingScreen();

    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text('Productos')
      ),
      body: ListView.builder(
        itemCount: productSercive.prodcuts.length,
        itemBuilder: ( BuildContext context, int index) => GestureDetector(
          onTap: () {
            productSercive.selectedProduct = productSercive.prodcuts[index].copy();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard(product:  productSercive.prodcuts[index],),
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add) ,
        onPressed: () {
          productSercive.selectedProduct = new Product(
            available: false, 
            name: '', 
            price: 0);
          Navigator.pushNamed(context, 'product');
        },
      ),
   );
  }
}