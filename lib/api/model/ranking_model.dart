class RankingModel {
  int? idUser;
  String? name;
  int? score;
  int? flies;

  RankingModel(this.idUser, this.name, this.score, this.flies);

  RankingModel.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    name = json['name'];
    score = json['score'];
    flies = json['flies'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idUser'] = idUser;
    data['name'] = name;
    data['score'] = score;
    data['flies'] = flies;
    return data;
  }
}