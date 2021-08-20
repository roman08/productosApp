import 'package:flutter/material.dart';
import 'package:productosapp/providers/login_form_provider.dart';
import 'package:productosapp/ui/input_decorations.dart';
import 'package:provider/provider.dart';
import 'package:productosapp/widgets/widgets.dart';


class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox( height: 200),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox( height: 10),
                    Text('Ingreso', style: Theme.of(context).textTheme.headline4),
                    SizedBox( height: 30),
                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: _LoginForm(),
                    )
                  ] 
                )
              ),
              SizedBox( height: 50),
              Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18,)),
              SizedBox( height: 50),
            ]
          ),
        )
      )
   );
  }
}


class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
             TextFormField(
               autocorrect: false,
               keyboardType: TextInputType.emailAddress,
               decoration: InputDecorations.authInputDecoration(
                 hintText: 'John.doe@gmail.com',
                 labelText: 'Correo electrónico',
                 prefixIcon: Icons.alternate_email_outlined
               ),
              onChanged: (value) =>  loginForm.email = value,
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);

                return regExp.hasMatch(value ?? '') 
                ? null : 'El valor ingresado no tiene formato de correo';
              },
             ),
             SizedBox( height:30),
             TextFormField(
               autocorrect: false,
               obscureText: true,
               keyboardType: TextInputType.emailAddress,
               decoration: InputDecorations.authInputDecoration(
                  hintText: '******',
                 labelText: 'Contraseña',
                 prefixIcon: Icons.lock_outline
               ),
               onChanged: (value) =>  loginForm.password = value,
               validator: (value) {
                return (value != null && value.length >= 6) ? null : 'La contraseña puede ser de 6 caracteres';
              },
             ),
             SizedBox( height:30),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading
                  ? 'Espere'
                  : 'Ingresar', 
                  style: TextStyle(color: Colors.white)),
              ),
              onPressed: loginForm.isLoading ? null : () async{
                FocusScope.of(context).unfocus();
                if (!loginForm.isValidForm()) return;
                 loginForm.isLoading = true;
                await Future.delayed(Duration(seconds: 4));
                loginForm.isLoading = false;
                Navigator.pushReplacementNamed(context, 'home');
              }
            )
          ],
        )
      ),
    );
  }
}