import 'package:flutter/material.dart';
import 'package:productosapp/providers/login_form_provider.dart';
import 'package:productosapp/services/auth_service.dart';
import 'package:productosapp/ui/input_decorations.dart';
import 'package:provider/provider.dart';
import 'package:productosapp/widgets/widgets.dart';


class RegisterScreen extends StatelessWidget {

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
                    Text('Crear cuenta', style: Theme.of(context).textTheme.headline4),
                    SizedBox( height: 30),
                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: _LoginForm(),
                    )
                  ] 
                )
              ),
              SizedBox( height: 50),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'login'), 
                child: Text('Ingresar con tu cuenta', style: TextStyle(fontSize: 18, color:  Colors.black87)),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.2)),
                  shape: MaterialStateProperty.all(StadiumBorder())
                ),
              ),
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
                final authService = Provider.of<AuthService>(context, listen: false);
                if (!loginForm.isValidForm()) return;
                loginForm.isLoading = true;
                final String errorMessage = await authService.createUser(loginForm.email, loginForm.password);

                if(errorMessage == null) {
                  Navigator.pushReplacementNamed(context, 'home');
                }else {
                  print(errorMessage);
                  // todo: mostrar error
                  loginForm.isLoading = false;
                }
                // await Future.delayed(Duration(seconds: 2));

                
              }
            )
          ],
        )
      ),
    );
  }
}