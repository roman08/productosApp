import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:productosapp/screens/screens.dart';
import 'package:productosapp/services/services.dart';
 
void main() => runApp(AppState());
 
class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => ProductsService(),)
      ],
      child: MyApp(),
    );
  }
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos',
      initialRoute: 'login',
      routes: {
        'login'   : ( _ ) => LoginScreen() ,
        'home'    : ( _ ) => HomeScreen() ,
        'product' : ( _ ) => ProductScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0
        )
      ),
    );
  }
}