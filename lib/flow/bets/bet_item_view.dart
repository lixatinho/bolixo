
import 'package:bolixo/ui/shared/app_decoration.dart';
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

    return Center(
      child: Card(
        elevation: 0,
        color: const Color(0xFFF9F9F9),
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [

              // Home team
              Column(
                children: [
                  // Flag
                  teamFlag(bet.homeTeam.flagUrl),
                  // Name
                  teamName(bet.homeTeam.name, bet.homeTeam.tooltip)
                ]
              ),

              betField(homeScoreTextFieldController, homeGoalsChanged, true),
              matchScoreAndBet(bet.homeTeam),

              // Middle
              Column(
                children: [
                  betScoredPoints(),
                  versusText(),
                  dateText(bet.date),
                ],
              ),

              betField(awayScoreTextFieldController, awayGoalsChanged, false),
              matchScoreAndBet(bet.awayTeam),

              // Away team
              Column(
                  children: [
                    teamFlag(bet.awayTeam.flagUrl),
                    teamName(bet.awayTeam.name, bet.awayTeam.tooltip)
                  ]
              ),
            ]
          )
        )
      )
    );
  }

  Widget betField(
    TextEditingController controller,
    Function callback,
    bool isHomeTeam
  ) {
    double spaceBetweenTeams = 24;
    double space = 16;
    double marginLeft = isHomeTeam ? space : spaceBetweenTeams;
    double marginRight = !isHomeTeam ? space : spaceBetweenTeams;
    return Visibility(
      visible: bet.isBetEnabled,
      child: Tooltip(
        message: bet.betFieldTooltip,
        padding: EdgeInsets.only(left: marginLeft, right: marginRight),
        child: SizedBox(
          width: 45,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: AppDecoration.inputDecoration,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            maxLength: 2,
            textAlign: TextAlign.center,
            controller: controller,
            onChanged: (goals) => callback(controller.text),
            enabled: bet.isBetEnabled,
          )
        )
      )
    );
  }

  Widget matchScoreAndBet(TeamViewContent team) {
    return Visibility(
        visible: !bet.isBetEnabled,
        child: Column(
          children: [
            betText(team.scoreBet),
            actualScoreText(team.actualScore)
          ],
        ),
    );
  }

  Widget betText(String text) {
    return Visibility(
      visible: !bet.isBetEnabled && text.isNotEmpty,
      child: Tooltip(
        message: bet.savedBetTooltip,
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: SizedBox(
          width: 50,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        )
      )
    );
  }

  Widget actualScoreText(String text) {
    return Visibility(
        visible: !bet.isBetEnabled && text.isNotEmpty,
        child: Tooltip(
            message: bet.scoreTooltip,
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: SizedBox(
                width: 50,
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black38,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
            )
        )
    );
  }

  Widget teamFlag(String flagUrl) {
    return Padding(
        padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
        child: SizedBox(
          width: 50,
          child: CircleAvatar(
            backgroundImage: NetworkImage(flagUrl),
          ),
        )
    );
  }

  Widget teamName(String name, String tooltip) {
    return Tooltip(
      padding: const EdgeInsets.only(top: 6),
      message: tooltip,
      child: Text(
        name,
        style: const TextStyle(
            fontSize: 12,
            color: Colors.black
        ),
      ),
    );
  }

  Widget versusText() {
    return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
        child: const Text('X',
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 14,
          )
        )
    );
  }
  Widget dateText(DateViewContent? dateViewContent) {
    return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
        child: Text(dateViewContent?.value ?? "",
          style: TextStyle(
            color: dateViewContent?.color,
            fontSize: 11
          )
        )
    );
  }

  Widget betScoredPoints() {
    const double vPadding = 6;
    const double hPadding = 12;
    return Visibility(
      visible: bet.score.value.isNotEmpty,
      child: Tooltip(
        message: bet.earnedPointsTooltip,
        padding: const EdgeInsets.only(),
        child: Card(
          color: bet.score.background,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.only(top: vPadding, bottom: vPadding, right: hPadding, left: hPadding),
            child: Center(
              child: Text(
                bet.score.value,
                style: TextStyle(
                  color: bet.score.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          )
        )
      )
    );
  }
}