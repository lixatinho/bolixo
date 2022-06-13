class PalpiteModel {
  int? id;
  int? idMatch;
  int? idUser;
  int? golsTeam1;
  int? golsTeam2;
  int? score;
  String? datetime;

  PalpiteModel(
      this.id,
        this.idMatch,
        this.idUser,
        this.golsTeam1,
        this.golsTeam2,
        this.score,
        this.datetime);

  PalpiteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idMatch = json['idMatch'];
    idUser = json['idUser'];
    golsTeam1 = json['golsTeam1'];
    golsTeam2 = json['golsTeam2'];
    score = json['score'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idMatch'] = this.idMatch;
    data['idUser'] = this.idUser;
    data['golsTeam1'] = this.golsTeam1;
    data['golsTeam2'] = this.golsTeam2;
    data['score'] = this.score;
    data['datetime'] = this.datetime;
    return data;
  }
}
