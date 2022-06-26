class AuthResponse {
  bool? auth;
  String? token;

  AuthResponse({
    this.auth,
    this.token,
  });

  AuthResponse.fromJson(Map<String, dynamic> json) {
    auth = json['auth'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['auth'] = auth;
    data['token'] = token;

    return data;
  }
}
