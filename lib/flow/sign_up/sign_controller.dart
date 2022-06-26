import 'package:bolixo/flow/sign_up/sign_up.dart';
import '../../api/model/user_model.dart';
import '../../service/AuthService.dart';
import 'sign_view_content.dart';

class SingUpController {
  late SignUpState signUpState;
  late AuthFormType _authFormType;

  void onSubmitClicked(String name, String email, String password) {
    switch (_authFormType) {
      case AuthFormType.signIn:
        return signIn(email, password);
      case AuthFormType.signUp:
        return signUp(name, email, password);
    }
  }

  void signUp(String name, String email, String password) {
    UserModel user = {name, email, password} as UserModel;
    AuthService().createUser(user).then((response) {
      if (response != null) {
        signUpState.showSuccessMessage('usuário criado com sucesoo!');
        signUpState.navigateToLogin();
      }
    });
  }

  void signIn(String email, String password) {

  }

  void switchAuthType() {
    if(_authFormType == AuthFormType.signIn) {
      _authFormType = AuthFormType.signUp;
    } else {
      _authFormType = AuthFormType.signIn;
    }
    updateViewWithAuthType();
  }

  void onInit(SignUpState state, AuthFormType authFormType) {
    signUpState = state;
    _authFormType = authFormType;
    updateViewWithAuthType();
  }

  void updateViewWithAuthType() {
    signUpState.updateViewContent(
        SignViewContent.fromAuthType(_authFormType)
    );
  }
}
