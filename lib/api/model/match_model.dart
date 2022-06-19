import 'package:bolixo/api/model/team_model.dart';

class MatchModel {
  int? id;
  TeamModel? home;
  TeamModel? away;
  late DateTime matchDate;
  int? homeScore;
  int? awayScore;
  int? type;

  MatchModel({
    this.id,
    this.away,
    this.home,
    required this.matchDate,
    this.awayScore,
    this.homeScore,
    this.type
  });

  MatchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    home = json['home'] != null ? TeamModel.fromJson(json['home']) : null;
    away = json['away'] != null ? TeamModel.fromJson(json['away']) : null;
    matchDate = DateTime.parse(json['matchDate']);
    homeScore = json['homeScore'];
    awayScore = json['awayScore'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (home != null) {
      data['home'] = home!.toJson();
    }
    if (away != null) {
      data['away'] = away!.toJson();
    }
    data['matchDate'] = matchDate;
    data['homeScore'] = homeScore;
    data['awayScore'] = awayScore;
    data['type'] = type;
    return data;
  }
}

