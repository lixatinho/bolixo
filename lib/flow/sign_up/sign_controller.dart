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

    authService.initialize().then((value) {
      if(authService.isLoggedIn()) {
        signUpState.navigateToHome();
      } else {
        _authFormType = authFormType;
        updateViewWithAuthType();
      }
    });
  }

  void onSubmitClicked(String? name, String? email, String? password) {
    switch (_authFormType) {
      case AuthFormType.signIn:
        return signIn(name!, password!);
      case AuthFormType.signUp:
        return signUp(name!, email!, password!);
    }
  }

  void signUp(String name, String email, String password) async {
    UserModel user =
        UserModel(username: name, email: email, password: password);

    await authService.initialize();
    authService.createUser(user).then((response) {
      print('response $response');
      signUpState.navigateToLogin();
    }, onError: (error) {
      print('error signup $error');
    });
  }

  void signIn(String username, String password) async {
    UserModel user =
        UserModel(username: username, email: null, password: password);
    await authService.initialize();
    authService.login(user).then((response) {
      signUpState.navigateToHome();
    }, onError: (error) {
      print('error signin $error');
    });
    // do stuff
  }

  void switchAuthType() {
    if (_authFormType == AuthFormType.signIn) {
      _authFormType = AuthFormType.signUp;
    } else {
      _authFormType = AuthFormType.signIn;
    }
    updateViewWithAuthType();
  }

  void updateViewWithAuthType() {
    signUpState.updateViewContent(SignViewContent.fromAuthType(_authFormType));
  }
}
