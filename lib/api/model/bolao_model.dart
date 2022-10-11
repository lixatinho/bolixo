class BolaoModel {
  String? name;
  int? idBolao;

  BolaoModel({
    this.name,
    this.idBolao
  });

  BolaoModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    idBolao = json['idBolao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idBolao'] = idBolao;
    data['name'] = name;

    return data;
  }
}
