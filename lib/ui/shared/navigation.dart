import 'package:flutter/material.dart';

import '../home.dart';

void navigateToHome(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const Home(
        title: 'Bolixo'
      )
    )
  );
}