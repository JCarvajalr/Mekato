import 'package:flutter/material.dart';
import 'package:mekato/ui/core/mekato_colors.dart';
import 'package:mekato/ui/core/mekato_styles.dart';
import 'package:mekato/ui/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login", style: MekatoStyles.textTitle1),
            SizedBox(height: 30),
            TextField(
              controller: userInputController,
              decoration: InputDecoration(
                labelText: "Usuario",
                icon: Icon(Icons.person),
                enabledBorder: _inputBorder(),
                focusedBorder: _inputBorder(),
                disabledBorder: _inputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: userInputController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Contraseña",
                icon: Icon(Icons.password),
                enabledBorder: _inputBorder(),
                focusedBorder: _inputBorder(),
                disabledBorder: _inputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(MekatoColors.main),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: Text("Iniciar sesión"),
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    // if success
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(),
      ),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(),
    );
  }
}
