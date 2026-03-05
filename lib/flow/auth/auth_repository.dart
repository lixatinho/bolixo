import 'package:bolixo/api/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static final AuthRepository _instance = AuthRepository._internal();
  late SharedPreferences prefs;
  final String tokenKey = "tokenBolixo";
  final String avatarUrlKey = "avatarUrl";
  final String easterEggCompletedKey = "easterEggCompleted";
  final String usernameKey = "username";
  final String roleKey = "userRole";

  _AuthInitStatus _initStatus = _AuthInitStatus.notStarted;
  Future? _initializationFuture;

  factory AuthRepository() {
    return _instance;
  }

  AuthRepository._internal();

  Future initialize() async {
    if (_initStatus == _AuthInitStatus.finished) return this;
    if (_initStatus == _AuthInitStatus.started) return _initializationFuture;

    _initStatus = _AuthInitStatus.started;
    _initializationFuture = _initComputation();
    return _initializationFuture;
  }

  Future _initComputation() async {
    prefs = await SharedPreferences.getInstance();
    _initStatus = _AuthInitStatus.finished;
    return this;
  }

  String? getToken() => prefs.getString(tokenKey);

  String getAvatarUrl() {
    final avatarName = prefs.getString(avatarUrlKey);
    if (avatarName != null && avatarName.isNotEmpty) {
      return "assets/images/avatars/$avatarName.png";
    }
    return "assets/images/spiderman.gif";
  }

  String getUsername() => prefs.getString(usernameKey) ?? "";

  UserRole getRole() {
    String? roleStr = prefs.getString(roleKey);
    if (roleStr != null) {
      return UserRole.values.firstWhere((e) => e.toString().split('.').last == roleStr);
    }
    return UserRole.USER;
  }

  bool getEasterEggCompleted() => prefs.getBool(easterEggCompletedKey) ?? false;

  void removeToken() => prefs.remove(tokenKey);
  void removeAvatarUrl() => prefs.remove(avatarUrlKey);
  void removeUsername() => prefs.remove(usernameKey);
  void removeRole() => prefs.remove(roleKey);
  void removeEasterEggCompleted() => prefs.remove(easterEggCompletedKey);

  Future saveToken(String token) => prefs.setString(tokenKey, token);
  Future saveAvatarUrl(String url) => prefs.setString(avatarUrlKey, url);
  Future saveUsername(String name) => prefs.setString(usernameKey, name);
  Future saveRole(UserRole role) => prefs.setString(roleKey, role.toString().split('.').last);
  Future saveEasterEggCompleted(bool completed) => prefs.setBool(easterEggCompletedKey, completed);
}

enum _AuthInitStatus { notStarted, started, finished }
