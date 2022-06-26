class SignViewContent {
  AuthFormType type = AuthFormType.signIn;
  String headerText = "";
  String buttonText = "";
  bool isNameVisible = false;
  String switchText = "";

  SignViewContent({
    required this.type,
    required this.headerText,
    required this.buttonText,
    required this.isNameVisible,
    required this.switchText,
  });

  SignViewContent.fromAuthType(this.type) {
    switch(type) {
      case AuthFormType.signIn:
        headerText = "Entrar";
        buttonText = "Logar";
        isNameVisible = false;
        switchText = "Criar conta";
        break;
      case AuthFormType.signUp:
        headerText = "Criar conta";
        buttonText = "Criar";
        isNameVisible = true;
        switchText = "Ir para Login";
        break;
    }
  }
}

enum AuthFormType { signIn, signUp }