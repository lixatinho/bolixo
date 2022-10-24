import 'package:auto_size_text/auto_size_text.dart';
import 'package:bolixo/ui/shared/app_elevated_button.dart';
import 'package:bolixo/ui/shared/app_text_button.dart';
import 'package:bolixo/ui/shared/loading_widget.dart';
import 'package:flutter/material.dart';

import '../../ui/shared/app_decoration.dart';
import 'auth_view_content.dart';
import 'auth_viewcontroller.dart';

class AuthView extends StatefulWidget {
  final AuthFormType authFormType;
  // ignore: prefer_const_constructors_in_immutables
  AuthView({Key? key, required this.authFormType}) : super(key: key);

  @override
  AuthViewState createState() => AuthViewState(authFormType: authFormType);
}

class AuthViewState extends State<AuthView> {
  AuthViewContent viewContent = AuthViewContent();
  AuthViewController authViewController = AuthViewController();
  AuthFormType authFormType;
  String _name = "";
  String _email = "";
  String _password = "";
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  AuthViewState({required this.authFormType});

  @override
  initState() {
    super.initState();
    authViewController.onInit(this, authFormType);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    if(viewContent.isLoading) {
      return const LoadingWidget();
    } else {
      return Scaffold(
        body: Container(
          color: Colors.white,
          height: height,
          width: width,
          child: SafeArea(
              child: Column(
            children: <Widget>[
              SizedBox(height: height * 0.025),
              // showMessage(),
              SizedBox(height: height * 0.025),
              buildHeaderText(),
              SizedBox(height: height * 0.05),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(children: buildInputs() + buildButtons()),
                ),
              )
            ],
          )),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    authViewController.onDispose();
  }

  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void updateIsLoading(bool newIsLoadingValue) {
    setState(() {
      isLoading = newIsLoadingValue;
    });
  }

  void updateViewContent(AuthViewContent viewContent) {
    setState(() {
      this.viewContent = viewContent;
    });
  }

  InputDecoration buildSignUpDecoration(String hint) {
    return AppDecoration.inputDecoration.copyWith(hintText: hint);
  }

  List<Widget> buildButtons() {
    return [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: AppElevatedButton(
          onPressedCallback: () {
            authViewController.onSubmitClicked(_name, _email, _password);
          },
          text: viewContent.buttonText,
        )
      ),
      const SizedBox(height: 10),
      AppTextButton(
        onPressedCallback: () {
          authViewController.switchAuthType();
        },
        text: viewContent.switchText
      )
    ];
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];
    // Name
    textFields.add(TextFormField(
      keyboardType: TextInputType.name,
      onChanged: (value) => _name = value,
      style: const TextStyle(fontSize: 22.0),
      decoration: buildSignUpDecoration("Username"),
    ));

    textFields.add(const SizedBox(height: 20));

    if (viewContent.isEmailVisible) {
      // Email
      textFields.add(TextFormField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => _email = value,
        style: const TextStyle(fontSize: 22.0),
        decoration: buildSignUpDecoration("Email"),
      ));
      textFields.add(const SizedBox(height: 20));
    }

    // Password
    textFields.add(TextFormField(
      keyboardType: TextInputType.visiblePassword,
      onChanged: (value) => _password = value,
      style: const TextStyle(fontSize: 22.0),
      decoration: buildSignUpDecoration("Senha"),
      obscureText: true,
    ));

    textFields.add(const SizedBox(height: 20));
    // print("inputs ---:>$_name, $_email, $_password");
    return textFields;
  }

  AutoSizeText buildHeaderText() {
    return AutoSizeText(
      viewContent.headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 35,
        color: Color(0xFF191C50),
      ),
    );
  }
}
