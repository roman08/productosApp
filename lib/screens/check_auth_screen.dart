import 'package:flutter/material.dart';
import 'package:productosapp/screens/home_screen.dart';
import 'package:productosapp/screens/login_screen.dart';
import 'package:productosapp/services/auth_service.dart';
import 'package:provider/provider.dart';


class CheckAuthScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);
    
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readTolken(),
          builder: (BuildContext contex, AsyncSnapshot<String> snapshot){
            if( !snapshot.hasData) {
              return Text('Espere');
            }

            if ( snapshot.data == '') {
              
              Future.microtask(() {
                // Navigator.of(context).pushReplacementNamed('home');
                Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: ( _, __, ___,) => LoginScreen(),
                    transitionDuration: Duration( seconds: 0 )
                  ),
                );
              } 
              );
            } else {
               Future.microtask(() {
                // Navigator.of(context).pushReplacementNamed('home');
                Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: ( _, __, ___,) => HomeScreen(),
                    transitionDuration: Duration( seconds: 0 )
                  ),
                );
              } 
              );
            }

            return Container();
          }
        )
     ),
   );
  }
}