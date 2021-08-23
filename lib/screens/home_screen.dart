import 'package:flutter/material.dart';
import 'package:productosapp/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text('Productos')
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: ( BuildContext context, int index) => GestureDetector(
          onTap: () => Navigator.pushNamed(context, 'product'),
          child: ProductCard(),
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add) ,
        onPressed: () {},
      ),
   );
  }
}