import 'package:bolixo/ui/home.dart';
// import 'package:bolixo/ui/login.dart';
import 'package:bolixo/ui/sign_up.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'Bolão dos lixos';
  static const flavor = Flavor.mock;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      // home: const Home(title: appTitle)
      home: SignUp(authFormType: AuthFormType.signIn),
    );
  }
}

enum Flavor { mock, staging, production }
