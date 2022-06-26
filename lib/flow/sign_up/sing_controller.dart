import 'package:bolixo/flow/sign_up/sign_up.dart';
import 'package:dio/dio.dart';

import '../../api/model/user_model.dart';
import '../../service/AuthService.dart';

class SingUpController {
  late SignUp upState;
  void onButtonCreatClick(String name, email, password) {
    UserModel user = {name, email, password} as UserModel;
    AuthService().createUser(user).then((response) {
      if (response.email != null) {
        // se existe chama login
        onInit(AuthFormType.signIn);
      }
    });
  }

  void onInit(state) {
    // upState = state;
  }
}
