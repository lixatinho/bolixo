import 'package:bolixo/api/model/auth_response.dart';
import 'package:bolixo/api/model/user_model.dart';
import 'package:bolixo/flow/auth/auth_repository.dart';

import '../../api/auth/auth_api.dart';

class AuthService {
  late AuthApi api;
  late AuthRepository repository;

  AuthService() {
    repository = AuthRepository();
    api = AuthApi.getInstance();
  }

  Future initialize() async {
    await repository.initialize();
    return this;
  }

  bool isLoggedIn() {
    return repository.getToken() != null;
  }

  void logOff() {
    repository.removeToken();
    repository.removeAvatarUrl();
  }

  Future<bool> login(UserModel user) async {
    AuthResponse response = await api.login(user);
    if (response.auth == true) {
      await repository.saveToken(response.token!);
       if (response.avatarUrl != null) {
         await repository.saveAvatarUrl(response.avatarUrl!);
      }

      return Future.value(true);
    }
    return Future.value(false);
  }

  Future createUser(UserModel user) {
    return api.signUp(user);
  }
}
