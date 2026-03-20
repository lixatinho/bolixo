import 'package:bolixo/api/model/competition_model.dart';

class BolaoModel {
  String? name;
  int? bolaoId;
  bool isGlobal;
  String? inviteCode;
  String? creatorUsername;
  CompetitionModel? competition;

  BolaoModel({
    this.name,
    this.bolaoId,
    this.isGlobal = false,
    this.inviteCode,
    this.creatorUsername,
    this.competition,
  });

  BolaoModel.fromJson(Map<String, dynamic> json) : isGlobal = json['isGlobal'] ?? false {
    name = json['name'];
    bolaoId = json['idBolao'];
    inviteCode = json['inviteCode'];
    creatorUsername = json['creatorUsername'];
    competition = json['competition'] != null ? CompetitionModel.fromJson(json['competition']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idBolao'] = bolaoId;
    data['name'] = name;
    data['isGlobal'] = isGlobal;
    data['inviteCode'] = inviteCode;
    data['creatorUsername'] = creatorUsername;
    if (competition != null) {
      data['competition'] = competition!.toJson();
    }

    return data;
  }
}
