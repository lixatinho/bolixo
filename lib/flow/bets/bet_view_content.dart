import 'dart:ui';

import 'package:bolixo/api/model/bets_in_day_model.dart';
import 'package:bolixo/api/model/bet_model.dart';
import 'package:bolixo/ui/select_date_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/model/team_model.dart';

class BetsInDayViewContent {
  DateTime date;
  List<BetViewContent> betList;
  int totalScore;
  int maxScore;
  double accuracy;

  BetsInDayViewContent({
    required this.date,
    required this.betList,
    required this.totalScore,
    required this.maxScore,
    required this.accuracy,
  });

  static fromApiModel(BetsInDayModel betsInDayApiModel) {
    int totalScore = _calculateTotalScore(betsInDayApiModel);
    double accuracy = _calculateAccuracy(betsInDayApiModel, totalScore);
    return BetsInDayViewContent(
        date: betsInDayApiModel.date,
        totalScore: totalScore,
        accuracy: accuracy,
        maxScore: betsInDayApiModel.maxPointsInDay,
        betList: betsInDayApiModel.betList
            .map((betModel) => BetViewContent.fromApiModel(betModel))
            .toList()
            .cast<BetViewContent>());
  }

  static int _calculateTotalScore(BetsInDayModel betsInDayModel) {
    return betsInDayModel.betList
        .fold(0, (previousValue, bet) => bet.score ?? 0);
  }

  static double _calculateAccuracy(BetsInDayModel betsInDayModel, int total) {
    return total / betsInDayModel.maxPointsInDay;
  }
}

class BetViewContent {
  BetModel model;
  TeamViewContent homeTeam;
  TeamViewContent awayTeam;
  String type;
  ScoreViewContent score;
  bool isBetEnabled;
  String betFieldTooltip;
  String scoreTooltip;
  String earnedPointsTooltip;
  String savedBetTooltip;
  DateViewContent date;

  BetViewContent({
    required this.model,
    required this.homeTeam,
    required this.awayTeam,
    required this.type,
    required this.score,
    required this.isBetEnabled,
    required this.date,
    required this.betFieldTooltip,
    required this.scoreTooltip,
    required this.savedBetTooltip,
    required this.earnedPointsTooltip,
  });

  static fromApiModel(BetModel betApiModel) {
    return BetViewContent(
      model: betApiModel,
      homeTeam: TeamViewContent.fromApiModel(
        betApiModel.match?.home,
        betApiModel.homeScoreBet,
        betApiModel.match?.homeScore,
      ),
      awayTeam: TeamViewContent.fromApiModel(betApiModel.match?.away,
          betApiModel.awayScoreBet, betApiModel.match?.awayScore),
      date: DateViewContent.fromApiModel(betApiModel.match?.matchDate),
      type: _defineType(betApiModel.match!.type),
      score: ScoreViewContent.fromApiModel(betApiModel.score),
      isBetEnabled:
          betApiModel.match?.matchDate.isAfter(DateTime.now().toUtc()) == true,
      betFieldTooltip: "Aposta",
      scoreTooltip: "Resultado do jogo",
      savedBetTooltip: "Aposta",
      earnedPointsTooltip: " Pontos ganhos ",
    );
  }

  toApiModel() {
    return BetModel(
        id: model.id,
        match: model.match,
        homeScoreBet: int.tryParse(homeTeam.scoreBet),
        awayScoreBet: int.tryParse(awayTeam.scoreBet),
        score: model.score);
  }
}

class TeamViewContent {
  String name;
  String tooltip;
  String flagUrl;
  String scoreBet;
  String actualScore;

  TeamViewContent(
      {required this.name,
      required this.tooltip,
      required this.flagUrl,
      required this.scoreBet,
      required this.actualScore});

  static fromApiModel(TeamModel? teamApiModel, int? bet, int? actualScore) {
    return TeamViewContent(
        name: teamApiModel?.abbreviation ?? "",
        tooltip: teamApiModel?.name ?? "",
        flagUrl: teamApiModel?.flagUrl ?? "",
        scoreBet: bet?.toString() ?? "",
        actualScore: actualScore?.toString() ?? "");
  }

  String score() {
    return actualScore.isEmpty ? scoreBet : actualScore;
  }
}

class ScoreViewContent {
  String value;
  Color background;
  Color color;

  ScoreViewContent({
    required this.value,
    required this.background,
    required this.color,
  });

  static fromApiModel(int? score) {
    if (score == null) {
      return ScoreViewContent(
          value: "", background: Colors.transparent, color: Colors.transparent);
    }
    return ScoreViewContent(
        value: score > 0 ? "+ $score" : (score == 0 ? " $score " : "- $score "),
        color: score > 0 ? Colors.green : Colors.red,
        background: Colors.transparent);
  }
}

String _defineType(phase) {
  switch (phase) {
    case 0:
      return 'Grupos';
    case 1:
      return 'Oitavas de Final';
    case 2:
      return 'Quartas de Final';
    case 3:
      return 'Semi-Final';
    case 4:
      return 'Disputa 3° Lugar';
    case 5:
      return 'Final';
    default:
  }
  return 'Goku Win';
}

class DateViewContent {
  String value;
  Color color;

  DateViewContent({
    required this.value,
    required this.color,
  });

  static fromApiModel(DateTime? dateTime) {
    if (dateTime == null) {
      return DateViewContent(value: "", color: Colors.transparent);
    }
    DateFormat df = DateFormat('HH:mm');
    return DateViewContent(
      value: df.format(dateTime),
      color: Colors.black87,
    );
  }
}
