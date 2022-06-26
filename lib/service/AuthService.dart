import 'package:bolixo/api/model/user_model.dart';

import '../api/auth/auth_api.dart';

class AuthService {

  AuthApi api = AuthApi.getInstance();

  bool isLoggedIn() {
    return false;
  }

  Future<bool> login() {
    return Future.value(false);
  }

  Future<UserModel> createUser(UserModel user) {
    return api.signUp(user);
  }

  String? _getToken() {

  }

  void _saveToken(String token) {

  }
}