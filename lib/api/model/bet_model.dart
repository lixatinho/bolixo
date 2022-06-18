import 'package:bolixo/api/model/match_model.dart';

class BetModel {
  int? id;
  MatchModel? match;
  int? homeScoreBet;
  int? awayScoreBet;
  int? score;

  BetModel({
    this.id,
    this.match,
    this.awayScoreBet,
    this.homeScoreBet,
    this.score
  });

  BetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    match = json['match'] != null ? MatchModel.fromJson(json['match']) : null;
    score = json['homeScoreBet'];
    score = json['awayScoreBet'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (match != null) {
      data['match'] = match!.toJson();
    }
    data['homeScoreBet'] = homeScoreBet;
    data['awayScoreBet'] = awayScoreBet;
    data['score'] = score;
    return data;
  }
}
