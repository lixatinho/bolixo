import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Stream<String> get onAuthStateChanged =>
  //     _firebaseAuth.authStateChanges().map((User user) => user.uid);

  int? createUserWithEmailAndPassword(
      String email, String password, String name) {
    // function criar user
    // retorn user válido
    User user = User(name, email, password);
    var users = CreateUserUp().createUsers(user);
    CreateUserUp().generateUid(users);
    print("usuarios: $users");
    return user.uid;
  }

  User? validateLogin(String email, String password) {
    List<User> users = CreateUserUp().getUsers();
    CreateUserUp().generateUid(users);
    User? user = CreateUserUp().findUser(email, users);
    print('teste valida login ${user?.uid}');
    if (user == null) {
      return null;
    }

    return user;
  }

  signOut() {
    // tem que fazer
    // return _firebaseAuth.signOut();
  }
}

class NameValidator {
  static String? validate(String? value) {
    if (value.toString().isEmpty) {
      return "Nome não pode ser vazio";
    }
    if (value.toString().length < 2) {
      return "Nome deve ter mais que dois caracters";
    }
    if (value.toString().length > 50) {
      return "Para de shedizar";
    }
    // if(value.toString().isEmpty){

    // }

    return null;
  }
}

class EmailValidator {
  static String? validate(String? value) {
    if (value.toString().isEmpty) {
      return "Campo de email não pode ser vazio";
    }
    return null;
  }
}

class PasswordValidator {
  static String? validate(String? value) {
    if (value.toString().isEmpty) {
      return "Senha necessária";
    }
    return null;
  }
}

class CreateUserUp {
  // conexão com banco
  List<User> users = [
    User('pato', 'pato', 'pameupato'),
    User('caldas', 'caldas', '123'),
    User('teste', 'email', 'login'),
    User('silas', 'pombo', '123')
  ];
  // só pra teste
  List<User> createUsers(User user) {
    users.add(user);
    return users;
  }

  List<User> getUsers() {
    return users;
  }

  generateUid(List<User> users) {
    int i = 0;
    for (var obj in users) {
      obj.uid = i++;
    }
  }

  User? getUser(int uid) {
    User? user;
    for (var user in users) {
      if (uid == user.uid) {
        return user;
      }
    }
    return user;
  }

  User? findUser(String email, List<User> users) {
    User? user;
    // List<User> users = CreateUserUp().getUsers();
    for (var user in users) {
      if (user.email == email) {
        return user;
      }
    }
    return user;
  }
  // gerando lixosamente id

}

class User {
  String? name, email, password;
  int? uid; // só pra teste
  bool? login;
  User(this.name, this.email, this.password);

  // List<User> user = [User(id: id, username: username, email: email, website: website)]
}
