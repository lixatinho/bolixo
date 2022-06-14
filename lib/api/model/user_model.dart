class UserModel {
  int? id;
  String? username;
  String? email;

  UserModel({
    this.id,
    this.username,
    this.email
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;

    return data;
  }
}
