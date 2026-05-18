import 'competition_model.dart';

class BolaoModel {
  String? name;
  int? bolaoId;
  bool isGlobal;
  String? inviteCode;
  int? idUser;
  CompetitionModel? competition;

  BolaoModel({
    this.name,
    this.bolaoId,
    this.isGlobal = false,
    this.inviteCode,
    this.idUser,
    this.competition,
  });

  BolaoModel.fromJson(Map<String, dynamic> json) : isGlobal = json['isGlobal'] ?? false {
    name = json['name'];
    bolaoId = json['idBolao'];
    inviteCode = json['inviteCode'];
    idUser = json['idUser'];
    competition = json['competition'] != null ? CompetitionModel.fromJson(json['competition']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idBolao'] = bolaoId;
    data['name'] = name;
    data['isGlobal'] = isGlobal;
    data['inviteCode'] = inviteCode;
    data['idUser'] = idUser;
    if (competition != null) {
      data['competition'] = competition!.toJson();
    }

    return data;
  }
}
