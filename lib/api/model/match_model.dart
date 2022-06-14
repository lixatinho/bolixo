import 'package:bolixo/api/model/team_model.dart';

class MatchModel {
  int? idMatch;
  TeamModel? away;
  TeamModel? home;
  int? goalsAway;
  int? goalsHome;
  String? dtHour;
  int? type;

  MatchModel(
      {this.idMatch,
        this.away,
        this.home,
        this.goalsAway,
        this.goalsHome,
        this.dtHour,
        this.type});

  MatchModel.fromJson(Map<String, dynamic> json) {
    idMatch = json['idMatch'];
    away = json['away'] != null ? TeamModel.fromJson(json['away']) : null;
    home = json['home'] != null ? TeamModel.fromJson(json['home']) : null;
    goalsAway = json['goalsAway'];
    goalsHome = json['goalsHome'];
    dtHour = json['dtHour'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idMatch'] = idMatch;
    if (away != null) {
      data['away'] = away!.toJson();
    }
    if (home != null) {
      data['home'] = home!.toJson();
    }
    data['goalsAway'] = goalsAway;
    data['goalsHome'] = goalsHome;
    data['dtHour'] = dtHour;
    data['type'] = type;
    return data;
  }
}

