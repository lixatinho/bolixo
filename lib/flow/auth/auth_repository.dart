import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {

  late SharedPreferences prefs;
  final String tokenKey = "tokenBolixo";
  _AuthInitStatus _initStatus = _AuthInitStatus.NOT_STARTED;
  late Future initialization;

  Future initialize() async {
    switch(_initStatus) {
      case _AuthInitStatus.STARTED:
        return initialization;
      case _AuthInitStatus.NOT_STARTED:
        initialization = Future(_initComputation);
        return initialization;
      case _AuthInitStatus.FINISHED:
        return Future.value(this);
    }
  }

  Future _initComputation() async {
    _initStatus = _AuthInitStatus.STARTED;
    prefs = await SharedPreferences.getInstance();
    _initStatus = _AuthInitStatus.FINISHED;
    return Future.value(this);
  }

  String? getToken() {
    return prefs.getString(tokenKey);
  }

  Future saveToken(String token) async {
    await prefs.setString(tokenKey, token);
  }
}

enum _AuthInitStatus {
  NOT_STARTED,
  STARTED,
  FINISHED
}