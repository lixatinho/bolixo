import 'package:bolixo/api/bolao/bolao_api_interface.dart';
import 'package:bolixo/cache/bolao_cache.dart';
import 'package:dio/dio.dart';
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
    view!.updateIsLoading(true);
    switch (_authFormType) {
      case AuthFormType.signIn:
        signIn(name!, password!);
        break;
      case AuthFormType.signUp:
        signUp(name!, email!, password!);
        break;
      case AuthFormType.recoverPassword:
        recoverPassword(email!);
        break;
    }
  }

  void signUp(String name, String email, String password) async {
    UserModel user = UserModel(username: name, email: email, password: password);

    await authService.initialize();
    authService.createUser(user).then((response) {
      view!.updateIsLoading(false);
      view!.showSuccessMessage("Usuário criado com sucesso");
      switchAuthType();
    }, onError: (error) {
      view!.updateIsLoading(false);
      view!.showErrorMessage(error.toString());
    });
  }

  void signIn(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      view!.updateIsLoading(false);
      view!.showErrorMessage("Preencha todos os campos");
      return;
    }

    UserModel user = UserModel(username: username, email: null, password: password);
    await authService.initialize();
    authService.login(user).then((response) {
      if (response) {
        selectFirstBolao(() {
          navigateToHome(view!.context);
        });
      } else {
        view!.updateIsLoading(false);
        view!.showErrorMessage("Erro inesperado no login");
      }
    }, onError: (error) {
      view!.updateIsLoading(false);
      view!.showErrorMessage(error.toString());
    });
  }

  void recoverPassword(String email) async {
    if (email.isEmpty) {
      view!.updateIsLoading(false);
      view!.showErrorMessage("Informe seu e-mail");
      return;
    }

    await authService.initialize();
    authService.recoverPassword(email).then((value) {
      view!.updateIsLoading(false);
      view!.showSuccessMessage("E-mail de recuperação enviado!");
      goToLogin();
    }, onError: (error) {
      view!.updateIsLoading(false);
      view!.showErrorMessage(error.toString());
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

  void goToRecoverPassword() {
    _authFormType = AuthFormType.recoverPassword;
    updateViewWithAuthType();
  }

  void goToLogin() {
    _authFormType = AuthFormType.signIn;
    updateViewWithAuthType();
  }

  void updateViewWithAuthType() {
    view!.updateViewContent(AuthViewContent.fromAuthType(_authFormType));
  }

  void selectFirstBolao(Function callback) {
    api.initialize().then((value) {
      api.getBoloes().then((boloes) {
        if(boloes.isNotEmpty) {
          BolaoCache().updateBolao(boloes[0].bolaoId!, boloes[0].name!);
          callback();
        } else {
          view!.updateIsLoading(false);
          callback();
        }
      });
    }, onError: (error) {
      view!.updateIsLoading(false);
      view!.showErrorMessage("Erro ao carregar dados do bolão");
    });
  }

  void onDispose() {
    view = null;
  }
}
