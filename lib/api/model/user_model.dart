enum UserRole {
  USER,
  PREMIUM,
  ADMIN
}

class UserModel {
  int? id;
  String? username;
  String? password;
  String? email;
  String? avatar;
  UserRole? role;

  UserModel({
    this.id,
    this.username,
    this.password,
    this.email,
    this.avatar,
    this.role
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    avatar = json['avatar'];
    if (json['role'] != null) {
      role = UserRole.values.firstWhere((e) => e.toString().split('.').last == json['role']);
    } else {
      role = UserRole.USER;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['avatar'] = avatar;
    data['role'] = role?.toString().split('.').last;

    return data;
  }
}
