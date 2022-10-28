import '../easteregg/easteregg_api_interface.dart';

class AuthResponse {
  bool? auth;
  String? token;
  String? avatarUrl;
  String? username;
  bool? easterEggComplete;

  AuthResponse({
    this.auth,
    this.token,
    this.username,
    this.easterEggComplete,
  });

  AuthResponse.fromJson(Map<String, dynamic> json) {
    auth = json['auth'];
    token = json['token'];
    username = json['username'];
    avatarUrl = json['avatarUrl'];
    easterEggComplete = json['easterEggs'] != null ? json['easterEggs'].length >= EasterEggApi.easterEggTotal : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['auth'] = auth;
    data['token'] = token;
    data['avatarUrl'] = avatarUrl;
    data['username'] = username;
    data['easterEggComplete'] = false;

    return data;
  }
}
