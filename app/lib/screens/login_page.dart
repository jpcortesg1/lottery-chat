import 'package:app/components/button.dart';
import 'package:app/components/my_textfield.dart';
import 'package:app/screens/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  //email and pw controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwlController = TextEditingController();

  LoginPage({super.key});

  BuildContext? get context => null;

  void _handleLogin() {
    MaterialPageRoute(builder: (context) => const HomePage());
  }

  @override
  Widget build(context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            //Logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            //welcome message
            Text(
              "Bienvenido, te extrañamos!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            //email textfield
            MyTextfield(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(
              height: 10,
            ),
            // password
            MyTextfield(
              hintText: "Password",
              obscureText: false,
              controller: _pwlController,
            ),

            const SizedBox(
              height: 10,
            ),

            //login button
            MyButton(
              text: "Ingresar",
              onTap: _handleLogin,
            ),

            const SizedBox(
              height: 10,
            ),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Aún no tienes cuenta?",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              Text("Registrate ahora!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary)),
            ])
            //register now
          ],
        ));
  }
}
