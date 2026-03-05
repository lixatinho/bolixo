import 'package:bolixo/api/model/team_model.dart';
import 'package:intl/intl.dart';

class CompetitionModel {
  int? id;
  String? name;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? dateCreation;
  List<TeamModel>? teams;

  CompetitionModel({
    this.id,
    this.name,
    this.startDate,
    this.endDate,
    this.dateCreation,
    this.teams
  });

  CompetitionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['teams'] != null) {
      teams = <TeamModel>[];
      json['teams'].forEach((v) {
        teams!.add(TeamModel.fromJson(v));
      });
    }

    DateFormat dateFormat = DateFormat("dd/MM/yyyy");

    if (json['startDate'] != null) {
      startDate = dateFormat.parse(json['startDate']);
    }

    if (json['endDate'] != null) {
      endDate = dateFormat.parse(json['endDate']);
    }

    if (json['dateCreation'] != null) {
      dateCreation = DateTime.parse(json['dateCreation']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (teams != null) {
      data['teams'] = teams!.map((v) => v.toJson()).toList();
    }

    DateFormat dateFormat = DateFormat("dd/MM/yyyy");

    if (startDate != null) {
      data['startDate'] = dateFormat.format(startDate!);
    }

    if (endDate != null) {
      data['endDate'] = dateFormat.format(endDate!);
    }

    if (dateCreation != null) {
      data['dateCreation'] = dateCreation!.toIso8601String();
    }

    return data;
  }
}
