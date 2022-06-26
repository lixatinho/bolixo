import 'package:bolixo/flow/sign_up/sign_up.dart';
import 'package:dio/dio.dart';

import '../../api/model/user_model.dart';
import '../../service/AuthService.dart';

class SingUpController {
  late SignUpState signUpState;
  void onButtonCreatClick(String name, email, password) {
    UserModel user = {name, email, password} as UserModel;
    AuthService().createUser(user).then((response) {
      if (response != null) {
        // se existe chama login
        signUpState.sucessCreat('usuário criado com sucesoo!');
        signUpState.navigateToLogin();
      }
    });
  }

  void onInit(state) {
    signUpState = state;
    // signUpState.updateSetState(state);
  }
}
