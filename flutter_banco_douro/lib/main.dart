import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/ui/home_screen.dart';
import 'package:flutter_banco_douro/ui/login_screen.dart';

void main() {
  runApp(const BacoDouroApp());
}

class BacoDouroApp extends StatelessWidget {
  const BacoDouroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes:{
      "login": (context) => const LoginScreen(),
      "home": (context) => const HomeScreen(),
    }, initialRoute: "login",);
  }
}
