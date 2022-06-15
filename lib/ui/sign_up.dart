import 'package:bolixo/api/services/auth.dart';
import 'package:bolixo/ui/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../api/services/provider_widget.dart';

final primaryCollor = const Color(0xFF75A2EA);

// type login
enum AuthFormType { signIn, sinUp }

class SignUp extends StatefulWidget {
  final AuthFormType authFormType;
  // ignore: prefer_const_constructors_in_immutables
  SignUp({Key? key, required this.authFormType}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState(authFormType: this.authFormType);
}

class _SignUpState extends State<SignUp> {
  AuthFormType authFormType;

  _SignUpState({required this.authFormType});

  final formKey = GlobalKey<FormState>();
  String _email = '', _password = '', _name = '', _error = '';

  InputDecoration buildSignUpDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding:
          const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }

  bool validate() {
    final form = formKey.currentState;
    form!.save();
    if (form.validate()) {
      print('dentro do form ----------------------->>>>>>>>>>>>>');
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    print("submt on");
    print('form------>$_email, $_name, $_password');
    if (validate()) {
      print('validação ok');
      try {
        print('tryt');
        // print(FirebaseAuth.instance.currentUser.uid);
        final auth = Provider.of(context).auth;
        // final auth = Provider.of<Auth>(context, listen: false);
        print('dpois do auth');
        if (AuthFormType == AuthFormType.signIn) {
          print('singin errado');
          String uid = await auth.signInWithEmailAndPassword(_email, _password);
          print("Entrou krai ID $uid");
        } else {
          String uid = await auth.createUserWithEmailAndPassword(
              _email, _password, _name);
          print("criando o filhote $uid");
          // Todo fazer navegação por url
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const Home(title: 'bolão lixão')));
        }
      } catch (e) {
        print(e);
        setState(() {
          _error = e.toString();
        });
      }
    }
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;
    _submitButtonText = "Logar";
    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = "Criar Conta";
      _newFormState = "signUp";
      _submitButtonText = "Criar";
      print('singin');
    } else {
      _switchButtonText = "Logar ...";
      _newFormState = "signIn";
      _submitButtonText = "Login";
    }
    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            primary: Colors.white,
            onPrimary: Color(0xFF75A2EA),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _submitButtonText,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
          ),
          onPressed: submit,
        ),
      )
    ];
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    if (authFormType == AuthFormType.signIn) {
      textFields.add(TextFormField(
        keyboardType: TextInputType.name,
        onSaved: (value) => _name = value!,
        validator: NameValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpDecoration("Nome"),
      ));
      // space beetwin box
      textFields.add(SizedBox(height: 20));
    }

    textFields.add(TextFormField(
      // validator: EmailValidator, validar email
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) => _email = value!,
      validator: EmailValidator.validate,
      style: TextStyle(fontSize: 22.0),
      decoration: buildSignUpDecoration("Email"),
    ));
    textFields.add(SizedBox(height: 20));
    textFields.add(TextFormField(
      validator: PasswordValidator.validate,
      keyboardType: TextInputType.visiblePassword,
      onSaved: (value) => _password = value!,
      style: TextStyle(fontSize: 22.0),
      decoration: buildSignUpDecoration("Senha"),
      obscureText: true,
    ));
    textFields.add(SizedBox(height: 20));
    return textFields;
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = "Criar Conta ";
    } else {
      _headerText = "Criar";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 35,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: primaryCollor,
        height: _height,
        width: _width,
        child: SafeArea(
            child: Column(
          children: <Widget>[
            SizedBox(height: _height * 0.025),
            // showAlert(),
            SizedBox(height: _height * 0.025),
            buildHeaderText(),
            SizedBox(height: _height * 0.05),
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
  // @override
  // Widget build(BuildContext context) {
  //   final _width = MediaQuery.of(context).size.width;
  //   final _height = MediaQuery.of(context).size.height;
  //   return Scaffold(
  //     key: formKey,
  //     body: Form(
  //         child: Column(
  //       children: [
  //         buildHeaderText(),
  //       ],
  //     )),
  //   );
  // }
}
