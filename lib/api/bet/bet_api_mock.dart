import 'dart:math';

import 'package:bolixo/api/model/bets_in_day_model.dart';
import 'package:bolixo/api/model/match_model.dart';
import 'package:bolixo/api/model/team_model.dart';

import '../model/bet_model.dart';
import 'bet_api_interface.dart';

class MockBetApi implements BetApi {
  @override
  Future initialize() {
    return Future.value();
  }

  @override
  Future<List<BetsInDayModel>> getUserBets() {
    var random = Random();
    var today = DateTime.now().toUtc();
    int numberOfDays = 20;
    int betsInDay = 10;
    int middle = (numberOfDays / 2) as int;

    return Future.value(List.generate(
        numberOfDays,
        (daysIndex) => BetsInDayModel(
            date: today.add(Duration(days: daysIndex - middle)),
            maxPointsInDay: betsInDay * 5,
            betList: List.generate(betsInDay, (betsInDayIndex) {
              int homeScore = random.nextInt(5);
              int awayScore = random.nextInt(5);
              int homeBet = random.nextInt(5);
              int awayBet = random.nextInt(5);
              return BetModel(
                  id: betsInDayIndex,
                  match: MatchModel(
                      id: betsInDayIndex,
                      home: TeamModel(
                          id: betsInDayIndex * 2,
                          name: "Team ${betsInDayIndex * 2}",
                          flagUrl:
                              "https://lixolao-flags.s3.amazonaws.com/BRA.webp",
                          abbreviation: "T${betsInDayIndex * 2}"),
                      away: TeamModel(
                          id: betsInDayIndex * 2 + 1,
                          name: "Team ${betsInDayIndex * 2 + 1}",
                          flagUrl:
                              "https://lixolao-flags.s3.amazonaws.com/ARG.webp",
                          abbreviation: "T${betsInDayIndex * 2 + 1}"),
                      matchDate: today.add(Duration(days: daysIndex - middle)),
                      homeScore: homeScore,
                      awayScore: awayScore),
                  homeScoreBet: homeBet,
                  awayScoreBet: awayBet,
                  score: daysIndex > middle
                      ? null
                      : mockScore(homeScore, awayScore, homeBet, awayBet));
            }))));
  }

  int mockScore(int homeScore, int awayScore, int homeBet, int awayBet) {
    int score = 0;
    if (homeScore == homeBet) {
      score += 2;
    }
    if (awayScore == awayBet) {
      score += 2;
    }
    return score;
  }

  @override
  Future saveUserBets(List<BetModel> betList) {
    return Future.value();
  }

  @override
  Future<List<BetModel>> getBetsByBolaoAndMatch(int? matchId) {
    // TODO: implement getBetsByBolaoAndMatch
    throw UnimplementedError();
  }
}
