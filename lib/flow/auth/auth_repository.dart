import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  late SharedPreferences prefs;
  final String tokenKey = "tokenBolixo";
  _AuthInitStatus _initStatus = _AuthInitStatus.notStarted;
  late Future initialization;

  Future initialize() async {
    switch (_initStatus) {
      case _AuthInitStatus.started:
        return initialization;
      case _AuthInitStatus.notStarted:
        initialization = Future(_initComputation);
        return initialization;
      case _AuthInitStatus.finished:
        return Future.value(this);
    }
  }

  Future _initComputation() async {
    _initStatus = _AuthInitStatus.started;
    prefs = await SharedPreferences.getInstance();
    _initStatus = _AuthInitStatus.finished;
    return Future.value(this);
  }

  String? getToken() {
    return prefs.getString(tokenKey);
  }

  void removeToken() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove(tokenKey);
  }

  Future saveToken(String token) async {
    await prefs.setString(tokenKey, token);
  }
}

enum _AuthInitStatus { notStarted, started, finished }
