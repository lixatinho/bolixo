import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:bolixo/ui/home.dart';
import 'package:bolixo/ui/shared/app_behavior.dart';

import 'flow/sign_up/sign_view_content.dart';
import 'flow/sign_up/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'Bolão dos lixos';
  static const flavor = Flavor.staging;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      scrollBehavior: AppBehaviors.scrollBehavior,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      // home: const Home(title: appTitle)
      home: SignUp(authFormType: AuthFormType.signIn),
    );
  }
}

enum Flavor { mock, staging, production }
