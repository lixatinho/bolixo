class AuthResponse {
  bool? auth;
  String? token;
  String? avatarUrl;

  AuthResponse({
    this.auth,
    this.token,
  });

  AuthResponse.fromJson(Map<String, dynamic> json) {
    auth = json['auth'];
    token = json['token'];
    avatarUrl = json['avatarUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['auth'] = auth;
    data['token'] = token;
    data['avatarUrl'] = avatarUrl;

    return data;
  }
}
