import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  late SharedPreferences prefs;
  final String tokenKey = "tokenBolixo";
  final String avatarUrlKey = "avatarUrl";
  final String easterEggCompletedKey = "easterEggCompleted";
  final String usernameKey = "username";
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

  String getAvatarUrl() {
    final avatarName = prefs.getString(avatarUrlKey);
    if (avatarName != null && avatarName.isNotEmpty) {
      return "assets/images/avatars/$avatarName.png";
    }
    return "assets/images/spiderman.gif";
  }

  String getUsername() {
    return prefs.getString(usernameKey) ?? "";
  }

  bool getEasterEggCompleted() {
    return prefs.getBool(easterEggCompletedKey) ?? false;
  }

  void removeToken() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove(tokenKey);
  }

  void removeAvatarUrl() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove(avatarUrlKey);
  }

  void removeUsername() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove(avatarUrlKey);
  }

  void removeEasterEggCompleted() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove(easterEggCompletedKey);
  }

  Future saveToken(String token) async {
    await prefs.setString(tokenKey, token);
  }

  Future saveAvatarUrl(String url) async {
    await prefs.setString(avatarUrlKey, url);
  }

  Future saveUsername(String name) async {
    await prefs.setString(usernameKey, name);
  }

  Future saveEasterEggCompleted(bool easterEggCompleted) async {
    await prefs.setBool(easterEggCompletedKey, easterEggCompleted);
  }
}

enum _AuthInitStatus { notStarted, started, finished }
