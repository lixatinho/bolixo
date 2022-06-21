import 'package:bolixo/api/model/match_model.dart';

class BetModel {
  int? id;
  late MatchModel match;
  int? homeScoreBet;
  int? awayScoreBet;
  int? score;

  BetModel({
    this.id,
    required this.match,
    this.awayScoreBet,
    this.homeScoreBet,
    this.score
  });

  BetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    match = MatchModel.fromJson(json['match']);
    score = json['homeScoreBet'];
    score = json['awayScoreBet'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['match'] = match.toJson();
    data['homeScoreBet'] = homeScoreBet;
    data['awayScoreBet'] = awayScoreBet;
    data['score'] = score;
    return data;
  }
}
