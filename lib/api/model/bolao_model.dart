class BolaoModel {
  String? name;
  int? bolaoId;
  bool isGlobal;
  String? inviteCode;
  String? creatorUsername;

  BolaoModel({
    this.name,
    this.bolaoId,
    this.isGlobal = false,
    this.inviteCode,
    this.creatorUsername,
  });

  BolaoModel.fromJson(Map<String, dynamic> json) : isGlobal = json['isGlobal'] ?? false {
    name = json['name'];
    bolaoId = json['idBolao'];
    inviteCode = json['inviteCode'];
    creatorUsername = json['creatorUsername'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idBolao'] = bolaoId;
    data['name'] = name;
    data['isGlobal'] = isGlobal;
    data['inviteCode'] = inviteCode;
    data['creatorUsername'] = creatorUsername;

    return data;
  }
}
