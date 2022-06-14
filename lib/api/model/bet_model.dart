import 'package:bolixo/api/model/match_model.dart';
import 'package:bolixo/api/model/user_model.dart';

class BetModel {
  int? id;
  MatchModel? match;
  UserModel? user;
  int? goalsAway;
  int? goalsHome;
  int? score;
  String? betDate;

  BetModel(
      this.id,
      this.match,
      this.user,
      this.goalsAway,
      this.goalsHome,
      this.score,
      this.betDate);

  BetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    match = json['match'] != null ? MatchModel.fromJson(json['match']) : null;
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    score = json['score'];
    score = json['goalsAway'];
    score = json['goalsHome'];
    betDate = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    if (match != null) {
      data['match'] = match!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['score'] = score;
    data['goalsAway'] = goalsAway;
    data['goalsHome'] = goalsHome;
    data['datetime'] = betDate;
    return data;
  }
}
