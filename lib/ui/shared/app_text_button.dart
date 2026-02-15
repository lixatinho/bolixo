import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {

  final Function onPressedCallback;
  final String text;

  const AppTextButton({Key? key,
    required this.onPressedCallback,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressedCallback();
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.indigo,
          fontSize: 16,
          fontWeight: FontWeight.w500),
      )
    );
  }
}