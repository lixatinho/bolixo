class TeamModel {
  int? id;
  String? name;
  String? flagUrl;

  TeamModel({
    this.id,
    this.name,
    this.flagUrl
  });

  TeamModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    flagUrl = json['flagUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['flagUrl'] = flagUrl;
    return data;
  }
}