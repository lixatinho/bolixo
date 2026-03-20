import 'package:bolixo/flow/home_selector/home_selector_view.dart';
import 'package:flutter/material.dart';

import '../home.dart';

void navigateToHome(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const HomeSelectorView()
    )
  );
}

void navigateToBolaoHome(BuildContext context, {int initialIndex = 0}) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => Home(
        title: 'Bolixo',
        initialIndex: initialIndex,
      )
    )
  );
}
