class AuthViewContent {
  AuthFormType type = AuthFormType.signIn;
  bool isLoading = true;
  String headerText = "";
  String buttonText = "";
  bool isEmailVisible = false;
  String switchText = "";

  AuthViewContent();

  AuthViewContent.fromAuthType(this.type) {
    switch (type) {
      case AuthFormType.signIn:
        isLoading = false;
        headerText = "Entrar";
        buttonText = "Logar";
        isEmailVisible = false;
        switchText = "Criar conta";
        break;
      case AuthFormType.signUp:
        isLoading = false;
        headerText = "Criar conta";
        buttonText = "Criar";
        isEmailVisible = true;
        switchText = "Ir para Login";
        break;
    }
  }
}

enum AuthFormType { signIn, signUp }
