
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Palpite extends StatelessWidget {

  Palpite(match);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            width: 50,
            child: Image(
              image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
              width: 50,
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                textAlign: TextAlign.center,
              )
          ),
          SizedBox(
              width: 50,
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                textAlign: TextAlign.center,
              )
          ),
          const SizedBox(
            width: 50,
            child: Image(
              image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
              fit: BoxFit.fitWidth,
            ),
          ),
        ]
      )
    );
  }
}