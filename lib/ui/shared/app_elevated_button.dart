import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {

  final Function onPressedCallback;
  final String text;

  const AppElevatedButton({Key? key,
    required this.onPressedCallback,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
        ),
        primary: Colors.indigo),
      onPressed: () {
        onPressedCallback();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style:
          const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}