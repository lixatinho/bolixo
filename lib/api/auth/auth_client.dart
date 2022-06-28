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
      var response = await dio.post("$baseUrl/$loginPath", data: user.toJson());
      if (response.statusCode == 200) {
        print(response.data);
        var authResponse = AuthResponse.fromJson(response.data);
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
  Future<UserModel> signUp(UserModel user) async {
    try {
      var response =
          await dio.post("$baseUrl/$signUpPath", data: user.toJson());
      if (response.statusCode == 200) {
        print(response.data);
        var createdUser = UserModel.fromJson(response.data);
        return Future.value(createdUser);
      } else {
        return Future.error(response.statusCode);
      }
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }
}
