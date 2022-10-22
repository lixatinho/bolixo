class BolaoModel {
  String? name;
  int? bolaoId;

  BolaoModel({
    this.name,
    this.bolaoId
  });

  BolaoModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    bolaoId = json['idBolao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idBolao'] = bolaoId;
    data['name'] = name;

    return data;
  }
}
