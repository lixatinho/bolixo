import 'package:bolixo/flow/sign_up/sign_up.dart';
import '../../api/model/user_model.dart';
import '../../service/AuthService.dart';
import 'sign_view_content.dart';

class SingUpController {
  late SignUpState signUpState;
  late AuthFormType _authFormType;
  AuthService authService = AuthService();

  void onInit(SignUpState state, AuthFormType authFormType) {
    signUpState = state;
    _authFormType = authFormType;
    updateViewWithAuthType();
  }

  void onSubmitClicked(String name, String email, String password) {
    switch (_authFormType) {
      case AuthFormType.signIn:
        return signIn(email, password);
      case AuthFormType.signUp:
        return signUp(name, email, password);
    }
  }

  void signUp(String name, String email, String password) async {
    UserModel user = {name, email, password} as UserModel;
    await authService.initialize();
    authService.createUser(user).then((response) {
        signUpState.showSuccessMessage('usuário criado com sucesoo!');
        signUpState.navigateToLogin();
    }, onError: (error) {

    });
  }

  void signIn(String email, String password) async {
    await authService.initialize();
    // do stuff
  }

  void switchAuthType() {
    if(_authFormType == AuthFormType.signIn) {
      _authFormType = AuthFormType.signUp;
    } else {
      _authFormType = AuthFormType.signIn;
    }
    updateViewWithAuthType();
  }

  void updateViewWithAuthType() {
    signUpState.updateViewContent(
        SignViewContent.fromAuthType(_authFormType)
    );
  }
}
