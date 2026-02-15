import 'package:bolixo/api/model/team_model.dart';
import 'package:intl/intl.dart';

class MatchModel {
  int? id;
  TeamModel? home;
  TeamModel? away;
  late DateTime matchDate;
  int? homeScore;
  int? awayScore;
  int? type;

  var dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

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
    if(json['home'] != null) {
      home = json['home'] != null ? TeamModel.fromJson(json['home']) : null;
    }
    if(json['away'] != null) {
      away = json['away'] != null ? TeamModel.fromJson(json['away']) : null;
    }
    matchDate = dateFormat.parse(json['matchDate']);
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
    data['matchDate'] = dateFormat.format(matchDate);
    data['homeScore'] = homeScore;
    data['awayScore'] = awayScore;
    data['type'] = type;
    return data;
  }
}

