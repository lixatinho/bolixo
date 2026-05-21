import 'package:flutter/material.dart';
import '../main_shell.dart';

void navigateToHome(BuildContext context, {bool redirectBoloes = false}) {
  MainShell.navigate(context, tab: redirectBoloes ? 1 : 0);
}
