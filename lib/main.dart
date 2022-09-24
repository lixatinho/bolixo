import 'package:bolixo/flow/auth/auth_view.dart';
import 'package:bolixo/ui/shared/app_behavior.dart';
import 'package:flutter/material.dart';

import 'flow/auth/auth_view_content.dart';

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
        scaffoldBackgroundColor: Colors.white,
      ),
      // home: const Home(title: appTitle)
      home: AuthView(authFormType: AuthFormType.signIn),
    );
  }
}

enum Flavor { mock, staging, production, local }
