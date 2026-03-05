import 'package:bolixo/api/model/user_model.dart';

import '../easteregg/easteregg_api_interface.dart';

class AuthResponse {
  bool? auth;
  String? token;
  String? avatarUrl;
  String? username;
  bool? easterEggComplete;
  UserRole? role;

  AuthResponse({
    this.auth,
    this.token,
    this.username,
    this.easterEggComplete,
    this.role,
  });

  AuthResponse.fromJson(Map<String, dynamic> json) {
    auth = json['auth'];
    token = json['token'];
    username = json['username'];
    avatarUrl = json['avatarUrl'];
    easterEggComplete = json['easterEggs'] != null ? json['easterEggs'].length >= EasterEggApi.easterEggTotal : false;
    if (json['role'] != null) {
      role = UserRole.values.firstWhere((e) => e.toString().split('.').last == json['role']);
    } else {
      role = UserRole.USER;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['auth'] = auth;
    data['token'] = token;
    data['avatarUrl'] = avatarUrl;
    data['username'] = username;
    data['role'] = role?.toString().split('.').last;
    data['easterEggComplete'] = false;

    return data;
  }
}
