
import 'package:bolixo/ui/AppDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bet_view_content.dart';

class BetItemView extends StatelessWidget {

  BetViewContent bet;
  Function homeGoalsChanged;
  Function awayGoalsChanged;

  TextEditingController homeScoreTextFieldController = TextEditingController();
  TextEditingController awayScoreTextFieldController = TextEditingController();

  BetItemView({
    Key? key,
    required this.bet,
    required this.homeGoalsChanged,
    required this.awayGoalsChanged,
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
    const double spaceBetweenTeams = 12;

    return Center(
      child: Card(
        elevation: 0,
        color: const Color(0xFFF9F9F9),
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Home team
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 8, left: margin, right: margin),
                      child: SizedBox(
                        width: 50,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(bet.awayTeam.flagUrl),
                        ),
                      )
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      bet.homeTeam.name,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black
                      ),
                    ),
                  )
                ]
              ),
              // Home team score
              Padding(
                padding: const EdgeInsets.only(left: margin, right: spaceBetweenTeams),
                  child: SizedBox(
                    width: 50,
                    child: scoreText(homeScoreTextFieldController, homeGoalsChanged, bet)
                  )
              ),

              // Middle
              Container(
                padding: EdgeInsets.only(top: 32),
                child: Column(
                  children: [
                    // Versus text
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.1,
                          color: Colors.grey
                        )
                      ),
                      child: const Text('VS',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11
                        )
                      )
                    ),

                  // Result
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
                ),
              ),

              // Away team score
              Padding(
                padding: const EdgeInsets.only(left: spaceBetweenTeams, right: margin),
                  child: SizedBox(
                    width: 50,
                    child: scoreText(awayScoreTextFieldController, awayGoalsChanged, bet)
                )
              ),
              // Away team flag
              Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 8, left: margin, right: margin),
                        child: SizedBox(
                          width: 50,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(bet.awayTeam.flagUrl),
                          ),
                        )
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        bet.awayTeam.name,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black
                        ),
                      ),
                    )
                  ]
              ),
            ]
          )
        )
      )
    );
  }

  TextField scoreText(
    TextEditingController controller,
    Function callback,
    BetViewContent bet
  ) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: AppDecoration.inputDecoration,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      maxLength: 2,
      textAlign: TextAlign.center,
      controller: controller,
      onChanged: (goals) => callback(awayScoreTextFieldController.text),
      enabled: bet.isEnabled,
    );
  }
}