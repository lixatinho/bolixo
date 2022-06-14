class TeamModel {
  int? id;
  String? name;
  String? urlImage;

  TeamModel({this.id, this.name, this.urlImage});

  TeamModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    urlImage = json['urlImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['urlImage'] = this.urlImage;
    return data;
  }
}