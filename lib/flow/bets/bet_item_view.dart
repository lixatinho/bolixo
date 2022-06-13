
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bet_view_content.dart';

class BetItemView extends StatelessWidget {

  BetViewContent bet;

  BetItemView({Key? key, required this.bet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 50,
            child: Image(
              image: NetworkImage(bet.team1.flagUrl),
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
          SizedBox(
            width: 50,
            child: Image(
              image: NetworkImage(bet.team2.flagUrl),
              fit: BoxFit.fitWidth,
            ),
          ),
        ]
      )
    );
  }
}