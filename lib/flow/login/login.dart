import 'package:bolixo/api/model/user_model.dart';
import 'package:bolixo/ui/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      onChanged: (text) {
                        email = text;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: (text) {
                        password = text;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Password', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                        onPressed: () {
                          if (CompareUser().compare(User(email, password))) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Home(title: 'bolão lixão')));
                          } else {
                            print('errou email/senha, inseto!');
                          }
                        },
                        child: const Text('Entrar'))
                  ],
                ))),
      ),
    );
  }
}

class CompareUser {
  // conexão com banco
  List<User> users = [
    User('pato', 'pameupato'),
    User('caldas', '123'),
    User('email', 'login'),
    User('pombo', '123')
  ];
  bool compare(User user) {
    for (var obj in users) {
      if (obj.email == user.email && obj.password == user.password) {
        return true;
      }
    }
    return false;
  }
}

class User {
  String email = '';
  String password = '';
  User(this.email, this.password);

  // List<User> user = [User(id: id, username: username, email: email, website: website)]
}
