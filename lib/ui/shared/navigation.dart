import 'package:flutter/material.dart';

import '../home.dart';

void navigateToHome(BuildContext context, {bool redirectBoloes = false}) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => Home(
        title: 'Bolixo',
        redirectBoloes: redirectBoloes,
      )
    )
  );
}
