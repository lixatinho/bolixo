import 'package:flutter/material.dart';

import '../../flow/menu/menu_home_view.dart';

void navigateToHome(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const MenuHomeView()
    )
  );
}