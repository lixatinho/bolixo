import 'dart:ui';

import 'package:bolixo/api/model/bet_model.dart';
import 'package:flutter/material.dart';

import '../../api/model/team_model.dart';

class BetViewContent {
  TeamViewContent homeTeam;
  TeamViewContent awayTeam;
  ScoreViewContent score;

  BetViewContent({
    required this.homeTeam,
    required this.awayTeam,
    required this.score
  });

  static fromApiModel(BetModel betApiModel) {
    return BetViewContent(
        homeTeam: TeamViewContent.fromApiModel(
            betApiModel.match?.home,
            betApiModel.homeScoreBet,
            betApiModel.match?.homeScore,
        ),
        awayTeam: TeamViewContent.fromApiModel(
            betApiModel.match?.away,
            betApiModel.awayScoreBet,
            betApiModel.match?.awayScore
        ),
        score: ScoreViewContent.fromApiModel(betApiModel.score)
    );
  }
}

class TeamViewContent {
  String name;
  String flagUrl;
  String scoreBet;
  String actualScore;

  TeamViewContent({
    required this.name,
    required this.flagUrl,
    required this.scoreBet,
    required this.actualScore
  });

  static fromApiModel(TeamModel? teamApiModel, int? bet, int? actualScore) {
    return TeamViewContent(
        name: teamApiModel?.name ?? "",
        flagUrl: teamApiModel?.flagUrl ?? "",
        scoreBet: bet?.toString() ?? "",
        actualScore: actualScore?.toString() ?? ""
    );
  }

  String score() {
    return actualScore.isEmpty ? scoreBet : actualScore;
  }
}

class ScoreViewContent {
  String value;
  Color color;

  ScoreViewContent({
    required this.value,
    required this.color,
  });

  static fromApiModel(int? score) {
    return ScoreViewContent(
        value: score?.toString() ?? "",
        color: score != null && score > 0 ? Colors.green : Colors.red
    );
  }
}