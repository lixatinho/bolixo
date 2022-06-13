import 'package:bolixo/ui/home.dart';
import 'package:bolixo/ui/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'Bolão dos lixos';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const Home(title: appTitle)
      home: const Login(),
    );
  }
}
