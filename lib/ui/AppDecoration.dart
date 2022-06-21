import 'package:flutter/material.dart';

class AppDecoration {
  static final inputDecoration = InputDecoration(
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.blue)
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 0.1, color: Colors.grey)
    ),
    filled: true,
    fillColor: Colors.white,
    counter: Container(),
  );
}
