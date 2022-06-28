import 'dart:convert';
import 'dart:developer';

import 'package:bolixo/api/model/auth_response.dart';
import 'package:bolixo/api/model/user_model.dart';
import 'package:dio/dio.dart';

import 'auth_api.dart';

class AuthClient implements AuthApi {
  String baseUrl;
  String loginPath = "login";
  String signUpPath = "user";
  Dio dio = Dio();

  AuthClient({required this.baseUrl});

  @override
  Future<AuthResponse> login(UserModel user) async {
    try {
      var response =
          await dio.post("$baseUrl/$loginPath", data: jsonEncode(user));
      if (response.statusCode == 200) {
        print(response.data);
        AuthResponse authResponse = json.decode(response.data);
        return Future.value(authResponse);
      } else {
        return Future.error(response.statusCode);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  @override
  Future signUp(UserModel user) async {
    try {
      var response =
          await dio.post("$baseUrl/$signUpPath", data: jsonEncode(user));
      if (response.statusCode == 200) {
        print(response.data);
        return Future.value();
      } else {
        return Future.error(response.statusCode);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }
}
