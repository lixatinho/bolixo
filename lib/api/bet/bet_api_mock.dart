import 'dart:math';

import 'package:bolixo/api/model/BetsInDay.dart';
import 'package:bolixo/api/model/match_model.dart';
import 'package:bolixo/api/model/team_model.dart';

import '../model/bet_model.dart';
import 'bet_api_interface.dart';

class MockBetApi implements BetApi {

  @override
  Future<List<BetsInDay>> getUserBets() {
    var random = Random();
    var today = DateTime.now().toUtc();
    return Future.value(
      List.generate(10, (index) =>
        BetsInDay(
            date: today.add(Duration(days: index - 5)),
            betList: List.generate(10, (index) =>
              BetModel(
                id: index,
                match: MatchModel(
                  id: index,
                  home: TeamModel(
                    id: index * 2,
                    name: "Team ${index * 2}",
                    flagUrl: "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"
                  ),
                  away: TeamModel(
                    id: index * 2 + 1,
                    name: "Team ${index * 2 + 1}",
                    flagUrl: "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"
                  ),
                  matchDate: today.add(Duration(days: index - 5)),
                  homeScore: random.nextInt(5),
                  awayScore: random.nextInt(5)
                ),
                homeScoreBet: random.nextInt(5),
                awayScoreBet: random.nextInt(5),
                score: random.nextInt(5)
              )
            )
          )
        )
      );
  }
}