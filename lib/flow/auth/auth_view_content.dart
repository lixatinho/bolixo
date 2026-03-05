class AuthViewContent {
  AuthFormType type = AuthFormType.signIn;
  bool isLoading = true;
  String headerText = "";
  String buttonText = "";
  bool isEmailVisible = false;
  bool isNameVisible = true;
  bool isPasswordVisible = true;
  String switchText = "";

  AuthViewContent();

  AuthViewContent.fromAuthType(this.type) {
    switch (type) {
      case AuthFormType.signIn:
        isLoading = false;
        headerText = "Entrar";
        buttonText = "Logar";
        isEmailVisible = false;
        isNameVisible = true;
        isPasswordVisible = true;
        switchText = "Criar conta";
        break;
      case AuthFormType.signUp:
        isLoading = false;
        headerText = "Criar conta";
        buttonText = "Criar";
        isEmailVisible = true;
        isNameVisible = true;
        isPasswordVisible = true;
        switchText = "Ir para Login";
        break;
      case AuthFormType.recoverPassword:
        isLoading = false;
        headerText = "Recuperar senha";
        buttonText = "Enviar";
        isEmailVisible = true;
        isNameVisible = false;
        isPasswordVisible = false;
        switchText = "Voltar para Login";
        break;
    }
  }
}

enum AuthFormType { signIn, signUp, recoverPassword }
