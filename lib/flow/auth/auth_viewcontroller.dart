import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/cache/bolao_cache.dart';
import 'package:flutter/foundation.dart';

import '../../api/model/user_model.dart';
import '../../ui/shared/navigation.dart';
import 'auth_service.dart';
import 'auth_view.dart';
import 'auth_view_content.dart';

class AuthViewController {
  late AuthViewState? view;
  late AuthFormType _authFormType;
  AuthService authService = AuthService();
  BolaoApi api = BolaoApi.getInstance();

  void onInit(AuthViewState state, AuthFormType authFormType) {
    view = state;

    authService.initialize().then((value) {
      if (authService.isLoggedIn()) {
        selectFirstBolao(() {
          navigateToHome(view!.context);
        });
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
      view!.showSuccessMessage("Usuário criado com sucesso");
      switchAuthType();
    }, onError: (error) {
      if (kDebugMode) {
        print('error signup $error');
      }
    });
  }

  void signIn(String username, String password) async {
    UserModel user = UserModel(username: username, email: null, password: password);
    await authService.initialize();
    authService.login(user).then((response) {
      selectFirstBolao(() {
        navigateToHome(view!.context);
      });
    }, onError: (error) {
      if (kDebugMode) {
        print('error signin $error');
      }
    });
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
    view!.updateViewContent(AuthViewContent.fromAuthType(_authFormType));
  }

  void selectFirstBolao(Function callback) {
    api.initialize().then((value) {
      api.getBoloes().then((boloes) {
        if(boloes.isNotEmpty) {
          BolaoCache().bolaoId = boloes[0].bolaoId!;
          callback();
        } else {
          if(kDebugMode) {
            print('Error: user has no big balls');
          }
        }
      });
    });
  }

  void onDispose() {
    view = null;
  }
}
