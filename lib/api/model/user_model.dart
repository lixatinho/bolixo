class UserModel {
  int? id;
  String? username;
  String? password;
  String? email;
  String? avatar;

  UserModel({
    this.id,
    this.username,
    this.password,
    this.email,
    this.avatar
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['avatar'] = avatar;

    return data;
  }
}
