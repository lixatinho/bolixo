import 'package:bolixo/ui/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'Bolão dos lixos';
  static const flavor = Flavor.Mock;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(title: appTitle)
    );
  }
}

enum Flavor {
  Mock,
  Staging,
  Production
}