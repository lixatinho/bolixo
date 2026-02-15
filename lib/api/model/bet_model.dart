import 'package:bolixo/api/model/match_model.dart';
import 'package:bolixo/api/model/user_model.dart';

class BetModel {
  int? id;
  MatchModel? match;
  int? homeScoreBet;
  int? awayScoreBet;
  int? score;
  UserModel? user;

  BetModel({
    this.id,
    required this.match,
    this.awayScoreBet,
    this.homeScoreBet,
    this.score,
    this.user
  });

  BetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if(json['match'] != null) {
      match = MatchModel.fromJson(json['match']);
    }
    homeScoreBet = json['homeScoreBet'];
    awayScoreBet = json['awayScoreBet'];
    score = json['score'];
    if(json['user'] != null) {
      user = UserModel.fromJson(json['user']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['match'] = match?.toJson();
    data['homeScoreBet'] = homeScoreBet;
    data['awayScoreBet'] = awayScoreBet;
    data['score'] = score;
    data['user'] = user?.toJson();
    return data;
  }
}
