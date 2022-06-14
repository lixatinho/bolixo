
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bet_view_content.dart';

class BetItemView extends StatelessWidget {

  BetViewContent bet;
  Function goals1Changed;
  Function goals2Changed;

  TextEditingController goals1TextFieldController = TextEditingController();
  TextEditingController goals2TextFieldController = TextEditingController();

  BetItemView({
    Key? key,
    required this.bet,
    required this.goals1Changed,
    required this.goals2Changed,
  }) : super(key: key);

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
                controller: goals1TextFieldController,
                onChanged: (goals) => goals1Changed(goals1TextFieldController.text),
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
                controller: goals2TextFieldController,
                onChanged: (goals) => goals2Changed(goals2TextFieldController.text),
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