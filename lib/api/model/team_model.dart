class TeamModel {
  int? id;
  String? name;
  String? flagUrl;
  String? abbreviation;

  TeamModel({
    this.id,
    this.name,
    this.flagUrl,
    this.abbreviation
  });

  TeamModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    flagUrl = json['url'];
    abbreviation = json['abbreviation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['url'] = flagUrl;
    data['abbreviation'] = abbreviation;
    return data;
  }
}