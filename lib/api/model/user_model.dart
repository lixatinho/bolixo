class UserModel {
  int? id;
  String? username;
  String? password;
  String? email;

  UserModel({
    this.id,
    this.username,
    this.password,
    this.email
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;

    return data;
  }
}
