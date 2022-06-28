class SignViewContent {
  AuthFormType type = AuthFormType.signIn;
  String headerText = "";
  String buttonText = "";
  bool isEmailVisible = false;
  String switchText = "";

  SignViewContent({
    required this.type,
    required this.headerText,
    required this.buttonText,
    required this.isEmailVisible,
    required this.switchText,
  });

  SignViewContent.fromAuthType(this.type) {
    switch (type) {
      case AuthFormType.signIn:
        headerText = "Entrar";
        buttonText = "Logar";
        isEmailVisible = false;
        switchText = "Criar conta";
        break;
      case AuthFormType.signUp:
        headerText = "Criar conta";
        buttonText = "Criar";
        isEmailVisible = true;
        switchText = "Ir para Login";
        break;
    }
  }
}

enum AuthFormType { signIn, signUp }
