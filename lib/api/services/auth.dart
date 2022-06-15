import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map((User user) => user.uid);

  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    // update the username
    User userUpdateInfo = currentUser.user;
    await userUpdateInfo.updateProfile(displayName: name);
    await userUpdateInfo.reload();
    return userUpdateInfo.uid;
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

  signOut() {
    return _firebaseAuth.signOut();
  }
}

// class EmailValidator {
//   static String? validate(String? value) {
//     return value==null ||  value.isEmpty ? "Email can't be empty" : null;
//   }
// }

class NameValidator {
  static String? validate(String? value) {
    if (value.toString().isEmpty) {
      return "Nome não pode ser vazio, Lixo de merda";
    }
    if (value.toString().length < 4) {
      return "Lixo deve ter 4 ou mais letras, sabe soletrar?";
    }
    // if (value.length > 50) {
    //   return "Para de shedizar";
    // }
    // if(value.toString().isEmpty){

    // }

    return null;
  }
}

class EmailValidator {
  static String? validate(String? value) {
    if (value.toString().isEmpty) {
      return "Campo de email não pode ser vazio, Lixoso de merda";
    }
    return null;
  }
}

class PasswordValidator {
  static String? validate(String? value) {
    if (value.toString().isEmpty) {
      return "Pqp, tu é burro, tem que digitar a senha";
    }
    return null;
  }
}
