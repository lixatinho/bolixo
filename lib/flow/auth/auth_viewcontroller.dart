import '../../api/model/user_model.dart';
import 'auth_service.dart';
import 'auth_view.dart';
import 'auth_view_content.dart';

class AuthViewController {
  late AuthViewState AuthView;
  late AuthFormType _authFormType;
  AuthService authService = AuthService();

  void onInit(AuthViewState state, AuthFormType authFormType) {
    AuthView = state;

    authService.initialize().then((value) {
      if(authService.isLoggedIn()) {
        AuthView.navigateToHome();
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
      AuthView.showSuccessMessage("Usuário criado com sucesso");
      switchAuthType();
    }, onError: (error) {
      print('error signup $error');
    });
  }

  void signIn(String username, String password) async {
    UserModel user =
        UserModel(username: username, email: null, password: password);
    await authService.initialize();
    authService.login(user).then((response) {
      AuthView.navigateToHome();
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
    AuthView.updateViewContent(AuthViewContent.fromAuthType(_authFormType));
  }
}
