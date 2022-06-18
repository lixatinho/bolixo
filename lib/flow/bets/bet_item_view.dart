
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bet_view_content.dart';

class BetItemView extends StatelessWidget {

  BetViewContent bet;
  Function goals1Changed;
  Function goals2Changed;

  TextEditingController homeScoreTextFieldController = TextEditingController();
  TextEditingController awayScoreTextFieldController = TextEditingController();

  BetItemView({
    Key? key,
    required this.bet,
    required this.goals1Changed,
    required this.goals2Changed,
  }) : super(key: key) {
    homeScoreTextFieldController = TextEditingController(
      text: bet.homeTeam.score()
    );
    awayScoreTextFieldController = TextEditingController(
        text: bet.awayTeam.score()
    );
  }

  @override
  Widget build(BuildContext context) {
    const double margin = 16;
    const double spaceBetweenTeams = 24;

    return Center(
      child: Column(
        children: [
          Card(
            elevation: 4,
            color: const Color(0xFFF9F9F9),
            child: Container(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                // Home team flag
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: margin, right: margin),
                    child: SizedBox(
                      width: 50,
                      child: Image(
                        image: NetworkImage(bet.homeTeam.flagUrl),
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  ),
                  // Home team score
                  Padding(
                    padding: const EdgeInsets.only(left: margin, right: spaceBetweenTeams),
                    child: SizedBox(
                      width: 50,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        controller: homeScoreTextFieldController,
                        onChanged: (goals) => goals1Changed(homeScoreTextFieldController.text),
                      )
                    )
                  ),
                  // Away team score
                  Padding(
                    padding: const EdgeInsets.only(left: spaceBetweenTeams, right: margin),
                    child: SizedBox(
                      width: 50,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        controller: awayScoreTextFieldController,
                        onChanged: (goals) => goals2Changed(awayScoreTextFieldController.text),
                      )
                    )
                  ),
                  // Away team flag
                  Padding(
                    padding: const EdgeInsets.only(left: margin, right: margin),
                    child: SizedBox(
                      width: 50,
                      child: Image(
                        image: NetworkImage(bet.awayTeam.flagUrl),
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  )
                ]
              )
            )
          ),
          // Score
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              bet.score.value,
              style: TextStyle(
                  color: bet.score.color
              ),
            ),
          )
        ]
      )
    );
  }
}