import 'package:bolixo/api/services/validateLogin.dart';
import 'package:bolixo/flow/sign_up/sign_controller.dart';
import 'package:bolixo/ui/AppDecoration.dart';
import 'package:bolixo/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'sign_view_content.dart';

int? uidC;
User? userC;

class SignUp extends StatefulWidget {
  final AuthFormType authFormType;
  // ignore: prefer_const_constructors_in_immutables
  SignUp({Key? key, required this.authFormType}) : super(key: key);

  @override
  SignUpState createState() => SignUpState(authFormType: this.authFormType);
}

class SignUpState extends State<SignUp> {
  late SignViewContent viewContent;
  SingUpController singUpController = SingUpController();
  AuthFormType authFormType;
  String? _name, _email, _password;
  final formKey = GlobalKey<FormState>();

  SignUpState({required this.authFormType});

  @override
  initState() {
    super.initState();
    singUpController.onInit(this, authFormType);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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

  void showSuccessMessage(String message) {}

  void navigateToLogin(AuthFormType authFormType) {
    if (authFormType == AuthFormType.signUp) {
      singUpController.onInit(this, AuthFormType.signIn);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Home(title: 'bolão lixão')));
    }
  }

  void updateViewContent(SignViewContent viewContent) {
    setState(() {
      this.viewContent = viewContent;
    });
  }

  InputDecoration buildSignUpDecoration(String hint) {
    return AppDecoration.inputDecoration.copyWith(
      hintText: hint
    );
  }

  List<Widget> buildButtons() {
    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            primary: Colors.indigo
          ),
          onPressed: () {
            singUpController.onSubmitClicked(_name, _email!, _password!);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              viewContent.buttonText,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ),
      TextButton(
          onPressed: () {
            singUpController.switchAuthType();
          },
          child: Text(
            viewContent.switchText,
            style: const TextStyle(
              color: Colors.indigo,
              fontSize: 16,
              fontWeight: FontWeight.w500
            ),
          ))
    ];
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    // Name
    if (viewContent.isNameVisible) {
      textFields.add(TextFormField(
        keyboardType: TextInputType.name,
        onChanged: (value) => _name = value,
        validator: NameValidator.validate,
        style: const TextStyle(fontSize: 22.0),
        decoration: buildSignUpDecoration("Nome"),
      ));
      // space beetwin box
      textFields.add(const SizedBox(height: 20));
    }

    // Email
    textFields.add(TextFormField(
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) => _email = value,
      validator: EmailValidator.validate,
      style: const TextStyle(fontSize: 22.0),
      decoration: buildSignUpDecoration("Email"),
    ));

    textFields.add(const SizedBox(height: 20));

    // Password
    textFields.add(TextFormField(
      validator: PasswordValidator.validate,
      keyboardType: TextInputType.visiblePassword,
      onChanged: (value) => _password = value,
      style: TextStyle(fontSize: 22.0),
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

  Widget showMessage() {
    // if (message != "") {
    return Container(
      color: Colors.amberAccent,
      width: double.infinity,
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.abc),
          ),
          Expanded(
              child: AutoSizeText(
            SingUpController().teste(),
            maxLines: 3,
          )),
        ],
      ),
    );
    // }
    //   return SizedBox(
    //     height: 0,
    //   );
  }
}
