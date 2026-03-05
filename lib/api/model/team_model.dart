class TeamModel {
  int? id;
  String? name;
  String? abbreviation;

  TeamModel({
    this.id,
    this.name,
    this.abbreviation,
  });

  TeamModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    abbreviation = json['abbreviation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['abbreviation'] = abbreviation;
    return data;
  }
}
